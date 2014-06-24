#!/usr/bin/env ruby
require 'yaml'
def cputs(string)
    puts "\033[1m#{string}\033[0m"
end

def cprint(string)
    print "\033[1m#{string}\033[0m"
end

@ptb_build     = `cd /usr/src/puppetlabs-training-bootstrap/ && git rev-parse --short HEAD`.strip

versions     = YAML.load_file('/usr/src/puppetlabs-training-bootstrap/version.yaml')
@ptb_version = "#{versions[:major]}.#{versions[:minor]}"
cputs "Puppet Labs Training VM #{@ptb_version} (Build #{@ptb_build})"
