#! /opt/puppet/bin/ruby
require 'hiera'

# Use MCO's fact cache because all nodes will have them
scope = YAML.load_file("/etc/puppetlabs/mcollective/facts.yaml")
hiera = Hiera.new(:config => "/etc/puppetlabs/puppet/hiera.yaml")

# Cribbed from Hiera source to ensure we're parsing the same way.
unless ARGV.empty?
  ARGV.each do |arg|
    if arg =~ /^(.+?)=(.+?)$/
      options[:scope][$1] = $2
    else
      unless options[:default]
        options[:default] = arg.dup
      else
        STDERR.puts "Don't know how to parse scope argument: #{arg}"
      end
    end
  end
end

puts 'Backend data directories:'
Hiera::Config[:backends].each do |backend|
  puts "  * #{backend}: #{Hiera::Backend.datadir(backend, scope)}"
end
puts

puts 'Expanded hierarchy:'
Hiera::Backend.datasources(scope) do |datasource|
  puts "  * #{datasource}"
end
puts

puts 'File lookup order:'
Hiera::Config[:backends].each do |backend|
  datadir = Hiera::Backend.datadir(backend, scope)
  next unless datadir

  Hiera::Backend.datasources(scope) do |source|
    path = File.join(datadir, "#{source}.#{backend}")
    puts "  * #{path}"
  end
end
puts
