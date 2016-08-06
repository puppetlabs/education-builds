#!/usr/bin/env ruby

require 'jmx'

client = JMX.connect(:host => ARGV.first, :port => ARGV.last)

metric_names = client.query_names("metrics:*")
metric_names.each do |metric_name|
   name_property = metric_name.get_key_property("name").sub(/^"/, "").sub(/"$/, "")
   if name_property.start_with?("puppetlabs.")
      puts name_property
      mbean = client[metric_name]
      mbean.attributes.each do |attribute|
         puts "\t#{attribute}: #{mbean[attribute]}"
      end
      puts
   end
end
