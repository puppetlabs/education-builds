#!/opt/puppet/bin/ruby
#  $stderr = File.new('/dev/null', 'w')

Dir.chdir "/root/.testing"
require 'rubygems'
require 'serverspec'
require 'pathname'
require 'yaml'
require 'trollop'

opts = Trollop::options do
  opt :progress, "Display details of tasks completed", :default => true
  opt :brief, "Display number of tasks completed"
  opt :name, "Name of the quest to track", :type => :string
  opt :completed, "Display completed quests"
  opt :showall, "Show all available quests"
  opt :start, "Provide name of the quest to start tracking", :type => :string
end

if opts[:showall] then
  puts "The following quests are available: "
  Dir.glob('/root/.testing/spec/localhost/*_spec.rb').each do |f|
    puts File.basename(f).gsub('_spec.rb','')
  end
  exit
end

if opts[:completed] then
  puts "The following quests have been completed! :"
  questlog = YAML::load_file('/root/.testing/log.yml')
  questlog.each do |key, value|
    if value.is_a?(Hash) then
        puts value['name']
    end
  end
  exit
end
  
if opts[:start] then
  questlog = YAML::load_file('/root/.testing/log.yml')
  if File.exist?("/root/.testing/spec/localhost/#{opts[:start]}_spec.rb") then
    questlog['current'] = opts[:start]
    File.open('/root/.testing/log.yml', 'w') { |f| f.write questlog.to_yaml }
    puts "You are starting the #{opts[:start]} quest."
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

  #c.before(:all, &:silence_output)
  #c.after(:all, &:enable_output)
end

# Redirects stderr and stdout to /dev/null.
def silence_output
  #@orig_stderr = $stderr
  #@orig_stdout = $stdout

  # redirect stderr and stdout to /dev/null
  #$stderr = File.new('/dev/null', 'w')
  #$stdout = File.new('/dev/null', 'w')
end

# Replace stdout and stderr so anything else is output correctly.
def enable_output
  $stderr = @orig_stderr
  $stdout = @orig_stdout
  @orig_stderr = nil
  @orig_stdout = nil
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

if opts[:progress] && !opts[:brief] && !opts[:start] then
  if failures.length != 0 then 
    STDOUT.puts "The following tasks were not completed:"
    failures.each { |x| puts " - #{x}" }
  end
  if successes.length != 0 then 
    STDOUT.puts "The following tasks were completed successfully! :"
    successes.each { |x| puts x }
  end
  STDOUT.puts "You successfully completed #{successes.length} tasks, out of a total of #{total} tasks!"
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
  STDOUT.puts "#{successes.length}/#{total}"
end
