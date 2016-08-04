#! /usr/bin/env ruby
# Quick script to generate JSON in proper format for the ec2classroom.rb script
# Accepts the enrollment csv files exported from learn.puppet.com

require 'json'
require 'csv'
require 'yaml'

filename = ARGV[0]
vms = JSON.parse(File.read(filename))

puts YAML.dump(vms)
