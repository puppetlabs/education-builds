#!/usr/bin/env ruby

require 'jmx'

client = JMX.connect(:host => ARGV.first, :port => ARGV.last)

#memory = client["java.lang:type=Memory"]
#puts memory.attributes

metric_names = client.query_names
metric_names.each do |metric_name|
   puts "Metric Name Class: #{metric_name.class}"
   puts "Metric Name toString: #{metric_name}"
   puts "Metric Domain: #{metric_name.domain}"
   puts "Metric Properties: #{metric_name.key_property_list_string}"
   puts
end
