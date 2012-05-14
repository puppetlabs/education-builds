require 'erb'
require 'uri'
require 'net/http'
require 'net/https'

STDOUT.sync = true
BASEDIR = File.dirname(__FILE__)
SITESDIR = ENV['HOME'] + "/Sites"
DATADIR = "#{SITESDIR}/ks"
MOUNTDIR = "#{SITESDIR}/dvd"
PEVERSION = '2.5.1'
PE_RELEASE_URL = "https://pm.puppetlabs.com/puppet-enterprise/#{PEVERSION}"
PE_DEV_URL = "http://pluto.puppetlabs.lan/ci-ready"
PE_URL = PE_RELEASE_URL # Set the place you want to get PE from

desc "Build and populate data directory"
task :init do
  [DATADIR, MOUNTDIR].each do |dir|
    unless File.directory?(dir)
      cputs "Making #{dir} for all kickstart data"
      FileUtils.mkdir(dir)
    end
  end

  unless File.exist?("#{DATADIR}/epel-release-5-4.noarch.rpm")
    cputs "Downloading EPEL rpm"
    download "http://mirrors.cat.pdx.edu/epel/5/i386/epel-release-5-4.noarch.rpm", "#{DATADIR}/epel-release-5-4.noarch.rpm"
  end

  unless File.exist?("#{DATADIR}/puppet-enterprise-#{PEVERSION}-el-5-i386.tar.gz")
    cputs "Downloading PE #{PEVERSION}"
    download "#{PE_URL}/puppet-enterprise-#{PEVERSION}-el-5-i386.tar.gz", "#{DATADIR}/puppet-enterprise-#{PEVERSION}-el-5-i386.tar.gz"
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

desc "Update the data directory and remount image"
task :update => :init

desc "Create a new vmware instance for kickstarting (unimplemented)"
task :createvm do
end

desc "Starts the kickstart (unimplemented)"
task :kickstart do
end

desc "Convert VMWare to VBox (unimplemented)"
task :convert do
end

desc "Package the VMs (unimplemented)"
task :package do
end

desc "Unmount the ISO and remove kickstart files and repos"
task :clean do
  system("hdiutil unmount #{MOUNTDIR}") or raise(Error, "Cannot unmount #{cdrompath}")
  FileUtils.rm_rf(DATADIR)
  FileUtils.rmdir(MOUNTDIR)
end

def download(url,path)
  u = URI.parse(url)
  net = Net::HTTP.new(u.host, u.port)
  case u.scheme
  when "http"
    net.use_ssl = false
  when "https"
    net.use_ssl = true
    net.verify_mode = OpenSSL::SSL::VERIFY_NONE
  else
    raise "Link #{url} is not HTTP(S)"
  end
  net.start do |http|
    resp = http.get(u.path)
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
