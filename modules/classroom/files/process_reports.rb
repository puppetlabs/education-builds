#! /opt/puppet/bin/ruby
#
# This script will parse reports saved in the reportdir and create a summary
# file located at ~/puppetruns.yaml with statistics about the last run from
# each host. This file could be then used as the source for a status dashboard
# for the infrastructure.
#
# This avoids explicitly setting the $LOAD_PATH
require 'puppet'
require 'fileutils'
require 'yaml'

Puppet.initialize_settings

username  = `who -m`.split.first
datafile  = File.expand_path("~#{username}/puppetruns.yaml")
reportdir = Puppet.settings[:reportdir]
stats     = {}

# If this were to be used in production, you would want to increment counts in
# the datafile and remove the source report files. This avoids a lot of
# unnecessary parsing and disk usage. Since these reports will be used by each
# student in the classroom, we will not do that here. Uncomment all the commented
# lines below to enable that functionality.

# begin
#   stats = YAML.load_file(datafile)
# rescue
#   stats = {}
# end

Dir.glob("#{reportdir}/*/*.yaml").each do |file|
  begin
    puts "Processing: #{file}"
    report = YAML.load_file(file)
    host   = report.host
    stats[host] = {
      :status => report.status,
      :time   => report.time,
    }
#    FileUtils.rm(file)
  rescue Exception => e
    puts "Error: #{e.inspect}"
  end
end

File.open(datafile, 'w') { |f| f.write stats.to_yaml }
