#! /opt/puppet/bin/ruby

require 'yaml'
require 'net/https'
require 'uri'
require 'json'
require 'openssl'

CONF = YAML.load_file('/etc/puppetlabs/console-auth/config.yml')

def build_auth(uri)
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  https.ca_file = CONF['ca_cert_file']
  https.key = OpenSSL::PKey::RSA.new(File.read(CONF['host_private_key_file']))
  https.cert = OpenSSL::X509::Certificate.new(File.read(CONF['host_cert_file']))
  https.verify_mode = OpenSSL::SSL::VERIFY_PEER
  https
end

def fetch_redirect(uri_str, limit = 10)
  raise ArgumentError, 'HTTP redirection has reached the limit beyond 10' if limit == 0

  uri = URI.parse("#{CONF['rbac_api_url']}#{uri_str}")
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
  uri = URI.parse("#{CONF['rbac_api_url']}#{endpoint}")
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

  uri = URI.parse("#{CONF['rbac_api_url']}#{endpoint}")
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
  uri = URI.parse("#{CONF['rbac_api_url']}#{endpoint}")
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
users  = get_response('/rbac-api/v1/users')
userid = users.select { |user| user['login'] == login }.first['id']
token  = post_response("/rbac-api/v1/users/#{userid}/password/reset", nil).body

reset = {
  'token'    => token,
  'password' => password,
}

resp = post_response("/rbac-api/v1/auth/reset", reset)

puts "Password for Console user #{login} changed to #{password}"
