#!/usr/bin/env ruby

require 'jmx'
require 'table_print'

client = JMX.connect(:host => ARGV.first, :port => ARGV.last)

metric_names = client.query_names("metrics:*")
functions = []
metric_names.each do |metric_name|
   name_property = metric_name.get_key_property("name").sub(/^"/, "").sub(/"$/, "")
   if match = name_property.match(/^puppetlabs\..*functions\.(.*)$/)
      mbean = client[metric_name]
      fname = match[1]
      mean = mbean["Mean"].nan? ? 0 : mbean["Mean"]
      count = mbean["Count"]
      functions << {:name => fname,
                    :mean => mean.round(2),
                    :count => count,
                    :aggregate => (mean * count).round(2)}
   end
end

sorted_functions = functions.sort_by { |v| - v[:aggregate] }

puts
puts "Function calls, sorted by total CPU time spent (in ms)"
puts

tp sorted_functions, :name, :aggregate, :count, :mean

puts
