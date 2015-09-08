#!/usr/bin/env ruby

require 'jmx'
require 'table_print'

MetricsId = ARGV.first.gsub(".#{`facter domain`.chomp}", '')

def client
   @client ||= JMX.connect(:host => ARGV.first, :port => ARGV.last)

end

def metric_name(name)
  if name =~ /\A[\w.-]+\z/
    "metrics:name=puppetlabs.#{MetricsId}.#{name}"
  else
    "metrics:name=\"puppetlabs.#{MetricsId}.#{name}\""
  end
end

def metric(name)
   client[metric_name(name)]
end

def canonical(name)
  if ['total', 'other', 'active' ].include? name
    name
  else
    "puppet-v3-#{name}-/\\*/"
  end
end

def request_count_info(request_type)
   mbean = metric("http.#{canonical(request_type)}-requests")
   mean = mbean["Mean"]
   count = mbean["Count"]
   {:name => request_type,
    :mean => mean.round(2),
    :count => count,
    :aggregate => (mean * count).round(2)}
end

def request_info(request_type, total)
   req_count_info = request_count_info(request_type)
   perc_count = (metric("http.#{canonical(request_type)}-percentage")["Value"] * 100).round(2)
   perc_time = ((req_count_info[:aggregate] / total[:aggregate]) * 100).round(2)
   req_count_info[:perc_count] = perc_count
   req_count_info[:perc_time] = perc_time
   req_count_info
end

puts

num_cpus = metric("num-cpus")["Value"]
active = metric("http.active-requests")["Count"]
active_histo = metric("http.active-histo")

puts "Active Request Statistics"
puts "------------------------------------"
puts "Num CPUs: #{num_cpus}"
puts "Current Active Requests: #{active}"
puts "Average Num Active Requests: #{active_histo["Mean"]}"
puts

total = request_count_info("total")
total[:perc_count] = 100
total[:perc_time] = 100
request_counts = []
request_counts << total
request_counts << request_info("catalog", total)
request_counts << request_info("node", total)
request_counts << request_info("report", total)
request_counts << request_info("other", total)
request_counts << request_info("file_metadatas", total)
request_counts << request_info("file_metadata", total)
request_counts << request_info("file_content", total)

puts "Request Statistics (time spent in ms; percentage of total requests, etc.)"
puts

ratios = request_counts.sort_by { |r| - r[:aggregate] }
tp ratios, :name, :aggregate, :count, :mean, :perc_count, :perc_time

puts
