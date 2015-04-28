#!/usr/bin/env ruby
#
# This script is designed to request classification from the Puppet Enterprise
# Node Classifier, giving us the opportunity to inject classes or parameter
# settings before returning the final classification.
#
# This is a terrible idea, and you should never do it in production.
#
require 'yaml'
require 'syslog'

begin
  # Request node classification and parse the data structure returned
  data = YAML.load(`/usr/local/bin/external_node.rb #{ARGV.first} --output yaml`)

  # Manipulate the data structure and inject a parameter here
  # Set $puppetlabs_course to 'architect'

  # return output to stdout
  puts data.to_yaml

rescue Exception => e
  Syslog.open('Puppet ENC', Syslog::LOG_PID | Syslog::LOG_CONS) do |syslog|
    syslog.warning "Configuration error for '#{ARGV.first}': #{e.message}"
  end

  # return error exit code
  exit 1
end
