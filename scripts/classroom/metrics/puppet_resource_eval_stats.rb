#!/usr/bin/env ruby

require 'jmx'
require 'table_print'

client = JMX.connect(:host => ARGV.first, :port => ARGV.last)

metric_names = client.query_names("metrics:*")
resources = []
metric_names.each do |metric_name|
   name_property = metric_name.get_key_property("name").sub(/^"/, "").sub(/"$/, "")
   if match = name_property.match(/^puppetlabs\..*compiler.evaluate_resource\.(.*)$/)
      mbean = client[metric_name]
      rname = match[1]
      mean = mbean["Mean"]
      count = mbean["Count"]
      resources << {:name => rname,
                    :mean => mean.round(2),
                    :count => count,
                    :aggregate => (mean * count).round(2)}
   end
end

sorted_resources = resources.sort_by { |v| - v[:aggregate] }

puts
puts "Resource evaluations during compile, sorted by total CPU time spent (in ms)"
puts

tp.set :max_width, 60
tp sorted_resources, :name, :aggregate, :count, :mean

puts
