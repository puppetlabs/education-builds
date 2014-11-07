#!/opt/puppet/bin/ruby
#
# The /nodes endpoint is now authenticated, and has an actual terminus.
# As such, the external_nodes script was deprecated. It was, however,
# useful for debugging, and for teaching how the node classifier works.
#
# This is a simple reimplementation that calls the actual endpoint for
# manual debugging. It will just show you the json representation of the
# node's classification. It should be called just like the old script.
#
# external_node.rb <node name>
#
# Minor improvements from https://gist.github.com/nicklewis/7a750cfa8985171ea18a

require 'json'
require 'net/http'
require 'openssl'
require 'socket'
require 'yaml'
require 'puppet'
require 'optparse'

class SimpleClassifier
  class HttpClient
    def initialize(server)
      cert   = Puppet.settings[:hostcert]     #`puppet master --configprint hostcert`.strip
      cacert = Puppet.settings[:localcacert]  #`puppet master --configprint localcacert`.strip
      prvkey = Puppet.settings[:hostprivkey]  #`puppet master --configprint hostprivkey`.strip

      @prefix = server.path
      @client = Net::HTTP.new(server.host, server.port).tap do |client|
        client.use_ssl = true
        client.cert    = OpenSSL::X509::Certificate.new(File.read(cert))
        client.key     = OpenSSL::PKey::RSA.new(File.read(prvkey))
        client.ca_file = cacert
      end
    end

    def get(uri)
      headers = {'Accept' => 'application/json'}
      result = @client.get(File.join(@prefix, uri), headers)

      if result.is_a? Net::HTTPSuccess
        JSON.parse(result.body)
      else
        raise "ERROR in request GET #{uri}: #{result.code} #{result.body}"
      end
    end

    def post(uri, body)
      headers = {'Accept' => 'application/json', 'Content-Type' => 'application/json'}
      result = @client.post(File.join(@prefix, uri), body, headers)

      if result.is_a? Net::HTTPSuccess
        JSON.parse(result.body)
      else
        raise "ERROR in request POST #{uri}: #{result.code} #{result.body}"
      end
    end
  end

  def initialize
    confdir = Puppet.settings[:confdir]  # `puppet master --configprint confdir`.strip

    puppetdb = File.readlines(File.join(confdir, 'puppetdb.conf')).grep(/=/).map do|line|
      line.split('=').map(&:strip)
    end
    puppetdb = Hash[puppetdb]
    @puppetdb = HttpClient.new(URI.parse("https://#{puppetdb['server']}:#{puppetdb['port']}"))

    classifier = YAML.load_file(File.join(confdir, 'classifier.yaml'))
    @classifier = HttpClient.new(URI.parse("https://#{classifier['server']}:#{classifier['port']}#{classifier['prefix']}"))
  end

  def facts(node)
    facts = @puppetdb.get("/v4/nodes/#{node}/facts")
    facts.inject { |h,fact| h.merge!(fact['name'] => fact['value']) }
  end

  def classify(node)
    facts = facts(node)
    trusted = facts.delete('trusted')
    body = {'fact'    => facts,
            'trusted' => trusted}.to_json

    @classifier.post("/v1/classified/nodes/#{node}", body)
  end
end

############ Now start execution ############

output = :json
optparse = OptionParser.new { |opts|
  opts.banner = "Usage : external_node.rb [--output yaml|json] <node name>

"

  opts.on("-o FORMAT", "--output FORMAT", "Choose the output format (yaml or json).") do |arg|
    output = arg.downcase.to_sym
  end

  opts.separator('')

  opts.on("-h", "--help", "Displays this help") do
    puts opts
    exit
  end
}
optparse.parse!

if ARGV.size != 1
  puts "Please call this script with the name of a node."
  puts "  example usage: external_node.rb <node name>"
  exit 1
end

Puppet.initialize_settings(['--confdir', '/etc/puppetlabs/puppet'])
data = SimpleClassifier.new.classify(ARGV[0])

case output
when :json
  puts JSON.pretty_generate(data)
when :yaml
  puts data.to_yaml
else
  puts "Unknown render format: #{output}"
end

