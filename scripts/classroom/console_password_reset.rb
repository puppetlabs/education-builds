#! /opt/puppetlabs/puppet/bin/ruby

require 'puppet'
require 'net/https'
require 'uri'
require 'json'
require 'openssl'
require 'yaml'

Puppet.initialize_settings

CONF = YAML.load_file("#{Puppet.settings[:confdir]}/classifier.yaml") rescue {}

def build_auth(uri)
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  https.ssl_version = :TLSv1
  https.ca_file = Puppet.settings[:localcacert]
  https.key = OpenSSL::PKey::RSA.new(File.read(Puppet.settings[:hostprivkey]))
  https.cert = OpenSSL::X509::Certificate.new(File.read(Puppet.settings[:hostcert]))
  https.verify_mode = OpenSSL::SSL::VERIFY_PEER
  https
end

def make_uri(path)
  # if the caller included a slash prefix, then remove it
  path.sub!(/^\//, '')
  URI.parse("https://#{CONF['server']}:#{CONF['port']}/rbac-api/v1/#{path}")
end

def fetch_redirect(uri_str, limit = 10)
  raise ArgumentError, 'HTTP redirection has reached the limit beyond 10' if limit == 0

  uri   = make_uri(uri_str)
  https = build_auth(uri)

  request = Net::HTTP::Get.new(uri.request_uri)
  res = https.request(request)

  case res
  when Net::HTTPSuccess then
    res
  when Net::HTTPRedirection then
    fetch_redirect(res['location'], limit - 1)
  else
    puts "An error occured: HTTP #{res.code}, #{res.to_hash.inspect}"
    exit 1
  end
end

def get_response(endpoint)
  uri   = make_uri(endpoint)
  https = build_auth(uri)

  request = Net::HTTP::Get.new(uri.request_uri)
  request['Content-Type'] = "application/json"
  res = https.request(request)

  if res.code != "200"
    puts "An error occured: HTTP #{res.code}, #{res.body}"
    exit 1
  end
  res_body = JSON.parse(res.body)

  res_body
end

def post_response(endpoint, request_body)
  limit = 10

  uri   = make_uri(endpoint)
  https = build_auth(uri)

  request = Net::HTTP::Post.new(uri.request_uri)
  request['Content-Type'] = "application/json"
  request.body = request_body.to_json
  res = https.request(request)
  case res
  when Net::HTTPSuccess then
    res
  when Net::HTTPRedirection then
    fetch_redirect(res['location'], limit - 1)
  else
    puts "An error occured: HTTP #{res.code}, #{res.to_hash.inspect}"
    exit 1
  end
end

def put_response(endpoint, request_body)
  uri   = make_uri(endpoint)
  https = build_auth(uri)

  request = Net::HTTP::Put.new(uri.request_uri)
  request['Content-Type'] = "application/json"
  request.body = request_body.to_json
  res = https.request(request)

  if res.code != "200"
    puts "An error occured: HTTP #{res.code}, #{res.body}"
    exit 1
  end
end

raise ArgumentError, 'Call this script with a username and new password' unless ARGV.size == 2

login, password = ARGV
users  = get_response('/users')
userid = users.select { |user| user['login'] == login }.first['id']
token  = post_response("/users/#{userid}/password/reset", nil).body

reset = {
  'token'    => token,
  'password' => password,
}

resp = post_response("/auth/reset", reset)

puts "Password for Console user #{login} changed to #{password}"

