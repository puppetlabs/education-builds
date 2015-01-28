class Puppet::Provider::Rbac_api < Puppet::Provider
  require 'yaml'
  require 'net/https'
  require 'uri'
  require 'json'
  require 'openssl'

  CONFIGFILE = '/etc/puppetlabs/console-auth/config.yml'

  confine :exists => CONFIGFILE

  # This is autoloaded by the master, so rescue the permission exception.
  CONF = YAML.load_file(CONFIGFILE) rescue {}

  def self.build_auth(uri)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.ca_file = CONF['ca_cert_file']
    https.key = OpenSSL::PKey::RSA.new(File.read(CONF['host_private_key_file']))
    https.cert = OpenSSL::X509::Certificate.new(File.read(CONF['host_cert_file']))
    https.verify_mode = OpenSSL::SSL::VERIFY_PEER
    https
  end

  def self.fetch_redirect(uri_str, limit = 10)
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
      raise Puppet::Error, "An RBAC API error occured: HTTP #{res.code}, #{res.to_hash.inspect}"
    end
  end

  def self.get_response(endpoint)
    uri = URI.parse("#{CONF['rbac_api_url']}#{endpoint}")
    https = build_auth(uri)

    request = Net::HTTP::Get.new(uri.request_uri)
    request['Content-Type'] = "application/json"
    res = https.request(request)

    if res.code != "200"
      raise Puppet::Error, "An RBAC API error occured: HTTP #{res.code}, #{res.body}"
    end
    res_body = JSON.parse(res.body)

    res_body
  end

  def self.post_response(endpoint, request_body)
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
      raise Puppet::Error, "An RBAC API error occured: HTTP #{res.code}, #{res.to_hash.inspect}"
    end
  end

  def self.put_response(endpoint, request_body)
    uri = URI.parse("#{CONF['rbac_api_url']}#{endpoint}")
    https = build_auth(uri)

    request = Net::HTTP::Put.new(uri.request_uri)
    request['Content-Type'] = "application/json"
    request.body = request_body.to_json
    res = https.request(request)

    if res.code != "200"
      raise Puppet::Error, "An RBAC API error occured: HTTP #{res.code}, #{res.body}"
    end
  end

end