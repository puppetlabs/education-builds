#!/bin/env ruby
require 'yaml'

def cputs(string)
  puts "\033[1m#{string}\033[0m"
end

Dir.chdir("/usr/src/puppetlabs-training-bootstrap/") do
  versions     = YAML.load_file('version.yaml')
  @ptb_version = "#{versions[:major]}.#{versions[:minor]}"

  @ptb_build = `git rev-parse --short HEAD`.strip
end

cputs "Puppet Labs Training VM #{@ptb_version} (Build #{@ptb_build})"
