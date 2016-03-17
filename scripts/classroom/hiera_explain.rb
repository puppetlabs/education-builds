#! /opt/puppetlabs/puppet/bin/ruby
require 'hiera'

# Use MCO's fact cache because all nodes will have them
scope = YAML.load_file("/etc/puppetlabs/mcollective/facts.yaml")
hiera = Hiera.new(:config => "/etc/puppetlabs/code/hiera.yaml")
scope['environment'] ||= 'production'

# data buckets
priority_lookup = {}
array_lookup    = {}
hash_lookup     = {}
hash_errors     = {}

# Cribbed from Hiera source to ensure we're parsing the same way.
unless ARGV.empty?
  ARGV.each do |arg|
    if arg =~ /^(.+?)=(.+?)$/
      scope[$1] = $2
    else
      STDERR.puts "Don't know how to parse scope argument: #{arg}"
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

    data = YAML.load_file(path) rescue {}
    priority_lookup = data.merge(priority_lookup)

    data.each do |key, value|
      array_lookup[key] ||= Array.new
      array_lookup[key] << value

      hash_lookup[key] ||= Hash.new
      if (value.class == Hash)
        hash_lookup[key].merge!(value)
      else
        hash_errors[key] ||= Array.new
        hash_errors[key]  << "#{source}.#{backend}"
      end
    end

  end
end
puts

puts 'Priority lookup results:'
priority_lookup.each { |key, value| puts "   * hiera('#{key}') => #{value}" }
puts

puts 'Array lookup results:'
array_lookup.each { |key, value| puts "   * hiera_array('#{key}') => #{value.inspect}" }
puts

puts 'Hash lookup results:'
hash_lookup.each do |key, value|
  print "   * hiera_hash('#{key}') => "
  if(hash_errors.has_key? key)
    puts "No hash datatype in #{hash_errors[key].inspect}"
  else
    puts value.inspect
  end
end
puts
