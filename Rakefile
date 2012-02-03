require 'erb'
require 'net/http'

STDOUT.sync = true
BASEDIR = File.dirname(__FILE__)
SITESDIR = ENV['HOME'] + "/Sites"
DATADIR = "#{SITESDIR}/ks"
MOUNTDIR = "#{SITESDIR}/dvd"
PEVERSION = '2.0.2'

desc "Build and populate data directory"
task :init do
  unless File.directory?(DATADIR)
    cputs "Making #{DATADIR} for all kickstart data"
    File.mkdir(DATADIR)
  end

  unless File.exist?("#{DATADIR}/epel-release-5-4.noarch.rpm")
    cputs "Downloading EPEL rpm"
    download "http://mirrors.cat.pdx.edu/epel/5/i386/epel-release-5-4.noarch.rpm", "#{DATADIR}/epel-release-5-4.noarch.rpm"
  end

  unless File.exist?("#{DATADIR}/puppet-enterprise-#{PEVERSION}-el-5-i386.tar.gz")
    cputs "Downloading PE #{PEVERSION}"
    download "https://pm.puppetlabs.com/puppet-enterprise/#{PEVERSION}/puppet-enterprise-#{PEVERSION}-el-5-i386.tar.gz", "#{DATADIR}/puppet-enterprise-#{PEVERSION}-el-5-i386.tar.gz"
  end

  cputs "Cloning puppet..."
  gitclone 'git://github.com/puppetlabs/puppet.git', "#{DATADIR}/puppet.git", 'master'

  cputs "Cloning facter..."
  gitclone 'git://github.com/puppetlabs/facter.git', "#{DATADIR}/facter.git", 'master'

  cputs "Cloning mcollective..."
  gitclone 'git://github.com/puppetlabs/marionette-collective.git', "#{DATADIR}/mcollective.git", 'master'

  ptbrepo_destination = "#{DATADIR}/puppetlabs-training-bootstrap.git"

  STDOUT.sync = true
  STDOUT.flush

  # Set PTB repo
  if File.exist?("#{ptbrepo_destination}/config")
    ptbrepo_default = File.read("#{ptbrepo_destination}/config").match(/url = (\S+)/)[1]
    ptbrepo = ptbrepo_default
    cputs "Current repo url: #{ptbrepo} (`rm` local repo to reset)"
  else
    # Set PTB user
    cprint "Please choose a github user for puppetlabs-training-bootstrap [puppetlabs]: "
    ptbuser = STDIN.gets.chomp
    ptbuser = 'puppetlabs' if ptbuser.empty?

    ptbrepo_default = "git@github.com:#{ptbuser}/puppetlabs-training-bootstrap.git"
    cprint "Please choose a repo url [#{ptbrepo_default}]: "
    ptbrepo = STDIN.gets.chomp
    ptbrepo = ptbrepo_default if ptbrepo.empty?
  end

  # Set PTB branch
  if File.exist?("#{ptbrepo_destination}/HEAD")
    ptbbranch_default = File.read("#{ptbrepo_destination}/HEAD").match(/.*refs\/heads\/(\S+)/)[1]
  else
    ptbbranch_default = 'master'
  end
  cprint "Please choose a branch to use for puppetlabs-training-bootstrap [#{ptbbranch_default}]: "
  ptbbranch = STDIN.gets.chomp
  ptbbranch = ptbbranch_default if ptbbranch.empty?
  cputs "Cloning ptb..."
  gitclone ptbrepo, ptbrepo_destination, ptbbranch

  # Mount ~/Sites/dvd from CentOS DVD
  if ! File.exist?("#{MOUNTDIR}/GPL")
    cprint "Please enter the path to CentOS DVD iso (drag 'n drop): "
    cdrompath = STDIN.gets.chomp
    system("hdiutil attach -mountpoint #{MOUNTDIR} #{cdrompath}") or raise(Error, "Cannot mount #{cdrompath}")
  else
    cputs "#{MOUNTDIR} is already mounted; skipping"
  end

  # Enable PHP for kickstart file
  httpd_conf = File.read('/private/etc/apache2/httpd.conf')
  if httpd_conf.match('#LoadModule php5_module')
    cputs 'Enabling php... (requires sudo)'
    `sudo sed -i -e 's^#LoadModule php5_module.*libexec/apache2/libphp5.so^LoadModule php5_module libexec/apache2/libphp5.so^' /private/etc/apache2/httpd.conf` or rais(Error, "Cannot enable php")
    `sudo apachectl restart` or raise(Error, "Cannot restart apache")
  else
    cputs "PHP already enabled... (skipping)"
  end

  cputs "Copying centos.php..."
  FileUtils.cp "#{Rake.application.find_rakefile_location[1]}/files/centos.php", DATADIR
end

desc "Create a new vmware instance for kickstarting (unimplemented)"
task :createvm do
  #puts "ActiveMQ: Extracting"
  #`tar zxvf #{BASEDIR}/data/apache-activemq-*.tar.gz`
  #`chmod 755 apache-activemq-5.4.2/bin/activemq`
  #puts "ActiveMQ: Writing config"
  #File.open("apache-activemq-5.4.2/conf/activemq.xml", "w") do |f|
  #  f.puts activemqconf
  #end
  #puts "MCollective: Cloning collective-builder repo"
  #`git clone #{BASEDIR}/data/mcollective-collective-builder`
  #puts "MCollective: Building 10 instances"
  #`cd mcollective-collective-builder && MC_NAME=mcollective MC_SERVER=localhost MC_USER=mcollective MC_PASSWORD=marionette MC_PORT=6163 MC_VERSION=1.1.2 MC_COUNT=10 MC_COUNT_START=0 MC_SSL=n MC_SOURCE=#{BASEDIR}/data/marionette-collective rake create`
  #puts "MCollective: Patching config"
  #file = File.open("#{BASEDIR}/mcollective-collective-builder/client/lib/mcollective.rb", "r+")
  #text = file.read
  #file.close
  #File.open("#{BASEDIR}/mcollective-collective-builder/client/lib/mcollective.rb", "w+") do |f|
  #  f.write text.gsub(/require 'optparse'/, "require 'optparse'\nrequire 'shellwords'")
  #end
  #puts "Demo: Created"
end

desc "Starts the kickstart (unimplemented)"
task :kickstart do
  #puts "ActiveMQ: Starting"
  #`apache-activemq-5.4.2/bin/activemq start`
  #puts "Demo: Sleeping 2 seconds for MQ to start"
  #sleep 2
  #puts "MCollective: Starting 10 instances"
  #`cd mcollective-collective-builder && rake start`
end

desc "Convert VMWare to VBox (unimplemented)"
task :convert do
end

desc "Package the VMs (unimplemented)"
task :package do
end

desc "Remove kickstart files and repos and unmount the ISO (unimplemented)"
task :clean => [:stop] do
  #puts "ActiveMQ: Stopping"
  #`apache-activemq-5.4.2/bin/activemq stop`
  #puts "Demo: Removing directories"
  #CLEANFILES = ["mcollective-collective-builder", "apache-activemq-5.4.2", "activemq-data"]
  #FileUtils.rm_rf(CLEANFILES)
  #puts "Demo: Done"
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

def gitclone(source,destination,branch)
  if File.directory?(destination) then
    system("cd #{destination} && (git fetch origin '+refs/heads/*:refs/heads/*' && git update-server-info && git symbolic-ref HEAD refs/heads/#{branch})") or raise(Error, "Cannot pull ${source}")
  else
    system("git clone --bare #{source} #{destination} && cd #{destination} && git update-server-info && git symbolic-ref HEAD refs/heads/#{branch}") or raise(Error, "Cannot clone #{source}")
  end
end

def cputs(string)
  puts "\033[1m#{string}\033[0m"
end

def cprint(string)
  print "\033[1m#{string}\033[0m"
end
# vim: set sw=2 sts=2 et tw=80 :
