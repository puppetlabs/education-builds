#! /usr/bin/env ruby
require 'yaml'

# Load classroom information from yaml file 
classroom = YAML.load(File.read(ARGV[0]))

classroom['vms'].each do |vm|
  puts vm['name']
  puts '-------------------------'
  puts classroom['publish_sets'][1]['url']
  vm['services'].each do |service|
    printf("port %i -- %s:%i\n", service['internal_port'], service['external_ip'], service['external_port'])
  end
  puts
end
