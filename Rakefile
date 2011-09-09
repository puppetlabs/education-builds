require 'erb'
require 'net/http'

STDOUT.sync = true
BASEDIR = File.dirname(__FILE__)
SITESDIR = ENV['HOME'] + "/Sites"
DATADIR = "#{SITESDIR}/ks"
MOUNTDIR = "#{SITESDIR}/dvd"

desc "Build and populate data directory"
task :setup do
  unless File.directory?(DATADIR)
    puts "\033[1mMaking #{DATADIR} for all kickstart data\033[0m"
    File.mkdir(DATADIR)
  end

  unless File.exists?("#{DATADIR}/epel-release-5-4.noarch.rpm")
    puts "\033[1mDownloading EPEL rpm\033[0m"
    download "http://mirrors.cat.pdx.edu/epel/5/i386/epel-release-5-4.noarch.rpm", "#{DATADIR}/epel-release-5-4.noarch.rpm"
  end

  unless File.exists?("#{DATADIR}/puppet-enterprise-1.2.1-el-5-i386.tar.gz")
    puts "\033[1mDownloading PE tarball\033[0m"
    download "https://pm.puppetlabs.com/puppet-enterprise/1.2.1/puppet-enterprise-1.2.1-el-5-i386.tar.gz", "#{DATADIR}/puppet-enterprise-1.2.1-el-5-i386.tar.gz"
  end

  puts "\033[1mDownloading activemq\033[0m"
  if File.exists? "/root/mcollective/apache-activemq-5.4.2-bin.tar.gz"
    system("cd #{BASEDIR}/data && cp /root/mcollective/apache-activemq-5.4.2-bin.tar.gz .")
  else
    system("cd #{BASEDIR}/data && wget http://apache.cs.utah.edu/activemq/apache-activemq/5.4.2/apache-activemq-5.4.2-bin.tar.gz")
  end
  puts "\033[1mCloning git://github.com/puppetlabs/marionette-collective.git\033[0m"
  system("cd #{BASEDIR}/data && git clone --bare git://github.com/puppetlabs/marionette-collective.git")
  puts "\033[1mCloning git://github.com/hunner/mcollective-collective-builder.git\033[0m"
  system("cd #{BASEDIR}/data && git clone --bare git://github.com/hunner/mcollective-collective-builder.git")
  puts "\033[1mDone\033[0m"
end

desc "Create a new vmware instance for kickstarting"
task :makevm do
  puts "ActiveMQ: Extracting"
  `tar zxvf #{BASEDIR}/data/apache-activemq-*.tar.gz`
  `chmod 755 apache-activemq-5.4.2/bin/activemq`
  puts "ActiveMQ: Writing config"
  File.open("apache-activemq-5.4.2/conf/activemq.xml", "w") do |f|
    f.puts activemqconf
  end
  puts "MCollective: Cloning collective-builder repo"
  `git clone #{BASEDIR}/data/mcollective-collective-builder`
  puts "MCollective: Building 10 instances"
  `cd mcollective-collective-builder && MC_NAME=mcollective MC_SERVER=localhost MC_USER=mcollective MC_PASSWORD=marionette MC_PORT=6163 MC_VERSION=1.1.2 MC_COUNT=10 MC_COUNT_START=0 MC_SSL=n MC_SOURCE=#{BASEDIR}/data/marionette-collective rake create`
  puts "MCollective: Patching config"
  file = File.open("#{BASEDIR}/mcollective-collective-builder/client/lib/mcollective.rb", "r+")
  text = file.read
  file.close
  File.open("#{BASEDIR}/mcollective-collective-builder/client/lib/mcollective.rb", "w+") do |f|
    f.write text.gsub(/require 'optparse'/, "require 'optparse'\nrequire 'shellwords'")
  end
  puts "Demo: Created"
end

desc "Starts the kickstart"
task :start do
  puts "ActiveMQ: Starting"
  `apache-activemq-5.4.2/bin/activemq start`
  puts "Demo: Sleeping 2 seconds for MQ to start"
  sleep 2
  puts "MCollective: Starting 10 instances"
  `cd mcollective-collective-builder && rake start`
end

desc "Convert VMWare to VBox"
task :convert do
end

desc "Package the VMs"
task :package do
end

desc "Pull repos and cp's kickstart file"
task :update do
  system("cd mcollective-collective-builder && rake update")
end

desc "Remove kickstart files and repos and unmount the ISO"
task :clean => [:stop] do
  puts "ActiveMQ: Stopping"
  `apache-activemq-5.4.2/bin/activemq stop`
  puts "Demo: Removing directories"
  CLEANFILES = ["mcollective-collective-builder", "apache-activemq-5.4.2", "activemq-data"]
  FileUtils.rm_rf(CLEANFILES)
  puts "Demo: Done"
end

desc "Mount the CentOS ISO"
task :mount do
  unless File.directory?(MOUNTDIR)
    puts "\033[1mMaking #{MOUNTDIR} for all kickstart data\033[0m"
    File.mkdir(MOUNTDIR)
  end
end

desc "Unmount the CentOS ISO"
task :unmount do
end

desc "File cabinent for file storage"
task :filecabinent do
end

def download(url,path)
  m = url.match(/(https?):\/\/([^\/]+)(\/.*)/)
  proto = m[1]
  urlhost = m[2]
  urlpath = m[3]
  case proto
  when "http"
    net = Net::HTTP
  when "https"
    net = Net::HTTPS
  else
    raise "Link #{url} is not HTTP(S)"
  end
  net.start(urlhost) do |http|
    resp = http.get(urlpath)
    open(path, "wb") do |file|
      file.write(resp.body)
    end
  end
end

def gitclone(source,destination)
  if File.directory?(destination) then
    system("cd #{destination} && git fetch origin '+refs/heads/*:refs/heads/*' && git update-server-info")
  else
    system("git clone --bare #{source} #{destination} && cd #{destination} && git update-server-info")
  end
end

# vim: set sw=2 sts=2 et tw=80 :
