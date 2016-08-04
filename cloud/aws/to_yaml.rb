#! /usr/bin/env ruby
# Quick script to convert JSON output to YAML which is a bit more human-readable

require 'json'
require 'yaml'

filename = ARGV[0]
vms = JSON.parse(File.read(filename))

puts YAML.dump(vms)
