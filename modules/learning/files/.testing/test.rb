#!/opt/puppet/bin/ruby

class String
def bold;           "\033[1m#{self}\033[22m" end 
def cyan;           "\033[36m#{self}\033[0m" end
def green;          "\033[32m#{self}\033[0m" end
end

Dir.chdir "/root/.testing"
require 'rubygems'
require 'serverspec'
require 'pathname'
require 'yaml'
require 'trollop'

opts = Trollop::options do
  opt :progress, "Display details of tasks completed"
  opt :brief, "Display number of tasks completed"
  opt :name, "Name of the quest to track", :type => :string
  opt :completed, "Display completed quests"
  opt :showall, "Show all available quests"
  opt :start, "Provide name of the quest to start tracking", :type => :string
  opt :current, "Name of the quest in progress"
end

given = opts.select { |key, value| key.to_s.match(/_given/)}
noargs = given.empty?

if opts[:showall] then
  puts "The following quests are available: "
  Dir.glob('/root/.testing/spec/localhost/*_spec.rb').each do |f|
    puts File.basename(f).gsub('_spec.rb','').capitalize
  end
  #exit
end

if opts[:completed] then
  puts "The following quests have been completed! :"
  questlog = YAML::load_file('/root/.testing/log.yml')
  questlog.each do |key, value|
    if value.is_a?(Hash) then
        puts value['name'].capitalize
    end
  end
  #exit
end

if opts[:current] then
  questlog = YAML::load_file('/root/.testing/log.yml')
  puts questlog['current'].capitalize
  #exit
end

if opts[:start] then
  questlog = YAML::load_file('/root/.testing/log.yml')
  if File.exist?("/root/.testing/spec/localhost/#{opts[:start]}_spec.rb") then
    questlog['current'] = opts[:start].downcase
    File.open('/root/.testing/log.yml', 'w') { |f| f.write questlog.to_yaml }
    puts "You are starting the #{opts[:start].capitalize} quest."
  else
    puts "Please select another quest. The Quest you specified does not exist."
    puts "The command: 'quests --showall' will list all available quests."
  end
end

if opts[:name].nil? then
  questlog = YAML::load_file('/root/.testing/log.yml')
  name = questlog['current']
else
  name = opts[:name]
end
  
include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.tty = true
  c.color_enabled = true
  c.add_formatter(:json)
  if ENV['ASK_SUDO_PASSWORD']
    require 'highline/import'
    c.sudo_password = ask("Enter sudo password: ") { |q| q.echo = false }
  else
    c.sudo_password = ENV['SUDO_PASSWORD']
  end

end

config = RSpec.configuration
json_formatter = RSpec::Core::Formatters::JsonFormatter.new(config.out)
reporter  = RSpec::Core::Reporter.new(json_formatter)
config.instance_variable_set(:@reporter, reporter)

## Run RSpec on the policies directory
RSpec::Core::Runner.run(["/root/.testing/spec/localhost/#{name}_spec.rb"])

total = 0
failures = []
successes = []
json_formatter.output_hash[:examples].each do |example|
  total += 1
  if example[:status] == 'failed' then
    failures.push example[:full_description]
  else
    successes.push example[:full_description]
  end
end
total = failures.length + successes.length

if opts[:progress] || noargs then
  if successes.length != 0 then 
    puts "", "The following tasks were completed successfully! :".green.bold
    successes.each { |x| puts " + #{x}" }
  end
  if failures.length != 0 then 
    puts "", "The following tasks are pending:".bold
    failures.each { |x| puts " _ #{x}" }
  end
  puts "", "You successfully completed #{successes.length} tasks, out of a total of #{total} tasks!".cyan
end

if successes.length == total then
  quests_complete = YAML::load_file('/root/.testing/log.yml')
  if !quests_complete.has_key?(name) then
    quests_complete["#{name}"] = Hash.new
    quests_complete["#{name}"]['name'] = "#{name}"
    quests_complete["#{name}"]['tasks'] = total
    quests_complete["#{name}"]['tasks_done'] = successes.length
    quests_complete["#{name}"]['time'] = Time.now.getutc
    File.open('/root/.testing/log.yml', 'w') {|f| f.write quests_complete.to_yaml }
  end
end

if opts[:brief]  then
  if total == 0 then
    puts "No"
  else
    puts "#{successes.length}/#{total}"
  end
end


