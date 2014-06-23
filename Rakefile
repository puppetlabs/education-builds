require 'erb'
require 'uri'
require 'net/http'
require 'net/https'
require 'rubygems'
require 'gpgme'
require 'nokogiri'

STDOUT.sync = true
BASEDIR = File.dirname(__FILE__)
SITESDIR = ENV['sitesdir'] || ENV['HOME'] + "/Sites"
BUILDDIR = "#{SITESDIR}/build"
CACHEDIR = "#{SITESDIR}/cache"
KSISODIR = "#{BUILDDIR}/isos"
VAGRANTDIR = "#{BUILDDIR}/vagrant"
OVFDIR = "#{BUILDDIR}/ovf"
VMWAREDIR = "#{BUILDDIR}/vmware"
VBOXDIR = "#{BUILDDIR}/vbox"
# To build test VMs from CI builds,
# Download the PE installer (tar.gz) from the appropriate place:
# eg: http://neptune.puppetlabs.lan/3.0/ci-ready/
# to ~/Sites/cache/
# then,
# Edit the PEVERSION to something like:
# PEVERSION = '3.0.1-rc0-58-g9275a0f'
PEVERSION = ENV['PEVERSION'] || '3.2.2'
PESTATUS = ENV['PESTATUS'] || 'release'
$settings = Hash.new

hostos = `uname -s`
if hostos =~ /Darwin/
  @ovftool_default = '/Applications/VMware OVF Tool/ovftool'
  @md5 = '/sbin/md5'
elsif hostos =~ /Linux/
  @ovftool_default = '/usr/bin/ovftool'
  @md5 = '/usr/bin/md5sum'
else
  abort("Not tested for this platform: #{hostos}")
end

# Bail politely when handed a 'vmos' that's not supported.
if ENV['vmos'] && ENV['vmos'] !~ /^(Centos|Ubuntu)$/
  abort("ERROR: Unrecognized vmos parameter: #{ENV['vmos']}")
end

# Bail if handed a 'vmtype' that's not supported.
if ENV['vmtype'] && ENV['vmtype'] !~ /^(training|learning)$/
  abort("ERROR: Unrecognized vmtype parameter: #{ENV['vmtype']}")
end

desc "Build and populate data directory"
task :init do
  [BUILDDIR, KSISODIR, CACHEDIR].each do |dir|
    unless File.directory?(dir)
      cputs "Making #{dir} for all kickstart data"
      FileUtils.mkdir_p(dir)
    end
  end

  ['Ubuntu','Centos'].each do |vmos|
    case vmos
    when 'Ubuntu'
      pe_install_suffix = '-ubuntu-12.04-i386'
      @ubuntu_pe_tarball, @ubuntu_agent_tarball = get_pe(pe_install_suffix)
    when 'Centos'
      pe_install_suffix = '-el-6-i386'
      @centos_pe_tarball, @centos_agent_tarball = get_pe(pe_install_suffix)
    end
    cputs "Getting PE tarballs for #{vmos}"
  end

  cputs "Cloning puppet..."
  gitclone 'git://github.com/puppetlabs/puppet.git', "#{CACHEDIR}/puppet.git", 'master'

  cputs "Cloning facter..."
  gitclone 'git://github.com/puppetlabs/facter.git', "#{CACHEDIR}/facter.git", 'master'

  cputs "Cloning hiera..."
  gitclone 'git://github.com/puppetlabs/hiera.git', "#{CACHEDIR}/hiera.git", 'master'

  ptbrepo_destination = "#{CACHEDIR}/puppetlabs-training-bootstrap.git"

  STDOUT.sync = true
  STDOUT.flush

  # Set PTB repo
  ptbrepo = nil || ENV['ptbrepo']
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
  ptbbranch_override = nil || ENV['ptbbranch']
  unless ptbbranch_override
    cprint "Please choose a branch to use for puppetlabs-training-bootstrap [#{ptbbranch_default}]: "
    @ptbbranch = STDIN.gets.chomp
    @ptbbranch = ptbbranch_default if @ptbbranch.empty?
  else
    @ptbbranch = ptbbranch_override
  end

  # Calculate the VM version and build numbers used in the kickstart template
  @ptb_build     = `git rev-parse --short #{@ptbbranch}`.strip
  @ptb_version ||= '[Testing Build]'

  cputs "Cloning ptb: #{ptbrepo}, #{ptbrepo_destination}, #{@ptbbranch}"
  gitclone ptbrepo, ptbrepo_destination, @ptbbranch
end




desc "Creates a modified ISO with preseed/kickstart"
task :createiso, [:vmos,:vmtype] do |t,args|
  args.with_defaults(:vmos => $settings[:vmos], :vmtype => $settings[:vmtype])
  prompt_vmos(args.vmos)
  prompt_vmtype(args.vmtype)
  case $settings[:vmos]
  when 'Ubuntu'
    # Parse templates and output in BUILDDIR
    $settings[:pe_install_suffix] = '-ubuntu-12.04-i386'
    if $settings[:vmtype] == 'training'
      $settings[:hostname] = "#{$settings[:vmtype]}.puppetlabs.vm"
    else
      $settings[:hostname] = "learn.localdomain"
    end
    $settings[:pe_tarball] = @ubuntu_pe_tarball
    # No variables
    build_file('lang')
    build_file('txt.cfg')
    build_file('isolinux.cfg')
    #template_path = "#{BASEDIR}/#{$settings[:vmos]}/#{filename}.erb"
    # Uses hostname, pe_install_suffix
    build_file('preseed.cfg')

    # Define ISO file targets
    files = {
      "#{BUILDDIR}/Ubuntu/lang"                       => '/isolinux/lang',
      "#{BUILDDIR}/Ubuntu/txt.cfg"                    => '/isolinux/txt.cfg',
      "#{BUILDDIR}/Ubuntu/isolinux.cfg"               => '/isolinux/isolinux.cfg',
      "#{BUILDDIR}/Ubuntu/preseed.cfg"                => '/puppet/preseed.cfg',
      "#{CACHEDIR}/puppet.git"                        => '/puppet/puppet.git',
      "#{CACHEDIR}/facter.git"                        => '/puppet/facter.git',
      "#{CACHEDIR}/puppetlabs-training-bootstrap.git" => '/puppet/puppetlabs-training-bootstrap.git',
      "#{CACHEDIR}/#{$settings[:pe_tarball]}"                     => "/puppet/#{$settings[:pe_tarball]}",
    }
  when 'Centos'
    # Parse templates and output in BUILDDIR
    $settings[:pe_install_suffix] = '-el-6-i386'
    if $settings[:vmtype] == 'training'
      $settings[:hostname] = "#{$settings[:vmtype]}.puppetlabs.vm"
    else
      $settings[:hostname] = "learn.localdomain"
    end

    $settings[:pe_tarball]    = @centos_pe_tarball
    $settings[:agent_tarball] = @centos_agent_tarball

    # No variables
    build_file('isolinux.cfg')
    # Uses hostname, pe_install_suffix
    build_file('ks.cfg')

    unless File.exist?("#{CACHEDIR}/epel-release.rpm")
      cputs "Downloading EPEL rpm"
      #download "http://mirrors.cat.pdx.edu/epel/5/i386/epel-release-5-4.noarch.rpm", "#{CACHEDIR}/epel-release.rpm"
      download "http://mirrors.cat.pdx.edu/epel/6/i386/epel-release-6-8.noarch.rpm", "#{CACHEDIR}/epel-release.rpm"
    end

    # Define ISO file targets
    files = {
      "#{BUILDDIR}/Centos/isolinux.cfg"               => '/isolinux/isolinux.cfg',
      "#{BUILDDIR}/Centos/ks.cfg"                     => '/puppet/ks.cfg',
      "#{CACHEDIR}/epel-release.rpm"                  => '/puppet/epel-release.rpm',
      "#{CACHEDIR}/puppet.git"                        => '/puppet/puppet.git',
      "#{CACHEDIR}/facter.git"                        => '/puppet/facter.git',
      "#{CACHEDIR}/hiera.git"                         => '/puppet/hiera.git',
      "#{CACHEDIR}/puppetlabs-training-bootstrap.git" => '/puppet/puppetlabs-training-bootstrap.git',
      "#{CACHEDIR}/#{$settings[:pe_tarball]}"         => "/puppet/#{$settings[:pe_tarball]}",
      "#{CACHEDIR}/#{$settings[:agent_tarball]}"      => "/puppet/#{$settings[:agent_tarball]}",
    }
  end
end

desc "Build a release VM"
task :release do
  require 'yaml'

  versions     = YAML.load_file('version.yaml')
  @ptb_version = "#{versions[:major]}.#{versions[:minor]}"
  cputs "Current release version #{@ptb_version}"

  release = env_prompt('Increment the release version? [Y/n]: ', 'RELEASE')
  if [ 'y', 'yes', '' ].include? release.downcase
    versions[:minor] += 1
    @ptb_version = "#{versions[:major]}.#{versions[:minor]}"
    File.write('version.yaml', versions.to_yaml)
    system("git commit version.yaml -m 'Updating for release #{@ptb_version}'")
  end

  cputs "Building release version #{@ptb_version}"
  Rake::Task[:everything].invoke
end

desc "Do everything!"
task :everything, [:vmos] do |t,args|
  args.with_defaults(:vmos => $settings[:vmos])
  prompt_vmos(args.vmos)

  Rake::Task[:init].invoke
  Rake::Task[:createiso].invoke($settings[:vmos])
  Rake::Task[:runpacker].invoke($settings)[:vmos])
  Rake::Task[:packagevm].invoke($settings[:vmos])
end

task :jenkins_everything, [:vmos] do |t,args|
  args.with_defaults(:vmos => $settings[:vmos])
  prompt_vmos(args.vmos)

  Rake::Task[:init].invoke
  Rake::Task[:createiso].invoke($settings[:vmos])
  Rake::Task[:runpacker].invoke($settings)[:vmos])
  Rake::Task[:packagevm].invoke($settings[:vmos])
  Rake::Task[:shipvm].invoke
  Rake::Task[:publishvm].invoke
end

desc "Zip up the VMs (unimplemented)"
task :packagevm, [:vmos] do |t,args|
  args.with_defaults(:vmos => $settings[:vmos])
  prompt_vmos(args.vmos)
  system("zip -rj '#{CACHEDIR}/#{$settings[:vmname]}-ovf.zip' '#{OVFDIR}/#{$settings[:vmname]}-ovf'")
  system("zip -rj '#{CACHEDIR}/#{$settings[:vmname]}-vmware.zip' '#{VMWAREDIR}/#{$settings[:vmname]}-vmware'")
  system("zip -rj '#{CACHEDIR}/#{$settings[:vmname]}-vbox.zip' '#{VBOXDIR}/#{$settings[:vmname]}-vbox'")
  system("#{@md5} '#{CACHEDIR}/#{$settings[:vmname]}-ovf.zip' > '#{CACHEDIR}/#{$settings[:vmname]}-ovf.zip.md5'")
  system("#{@md5} '#{CACHEDIR}/#{$settings[:vmname]}-vmware.zip' > '#{CACHEDIR}/#{$settings[:vmname]}-vmware.zip.md5'")
  system("#{@md5} '#{CACHEDIR}/#{$settings[:vmname]}-vbox.zip' > '#{CACHEDIR}/#{$settings[:vmname]}-vbox.zip.md5'")
  # zip & md5 vagrant
end

## Ship the VMs somewhere. These dirs are NFS exports mounted on the builder, so really only
## applicable to the Jenkins builds.
task :shipvm do
  # These currently map to int-resources.ops.puppetlabs.net
  case $settings[:vmtype]
  when /training/
    destdir = "/mnt/nfs/Training\ VM/"
  when /learning/
    destdir = "/mnt/nfs/Learning\ Puppet\ VM/"
  end
  FileUtils.cp_r Dir.glob("#{CACHEDIR}/#{$settings[:vmname]}*"), destdir, :verbose => true
end

## Publish to VMware
task :publishvm do
  if $settings[:vmtype] == 'learning'
    # Should probably move most of this to a method
    require 'yaml'
    # Make a local config file with vcenter/auth info.
    # Put a script on the vmdk to set the dhcp/dns for our internal vmware network. Put an init script in the kickstart
    # that will execute the above config, if it exists, and delete itself if it doesn't to keep the end-user
    # vm pristine
    sh "/bin/sudo /bin/vmware-mount #{VMWAREDIR}/#{$settings[:vmname]}-vmware/#{$settings[:vmname]}/#{$settings[:vmname]}-disk1.vmdk /mnt/vmdk"
    sh "/bin/sudo /bin/cp files/dnsconfig.sh /mnt/vmdk"
    if File.exist?("/mnt/vmdk/post.log")
      sh "/bin/sudo /bin/cp /mnt/vmdk/post.log ."
    end
    sh "/bin/sudo /bin/vmware-mount -d /mnt/vmdk"
    # Set the MAC address to avoid issues with loising the DNS record. These overwrit each other so there should never be a conflict.
    # This should probably be parameterized at some point, but the host name is fixed due to the certs.
    cputs "Setting MAC address"
    content = File.read(@vmxpath)
    content = content.gsub(/^ethernet0.addressType = "generated"/, "ethernet0.addressType = \"static\"\nethernet0.address = \"00:50:56:9B:E8:3A\"")
    File.open(@vmxpath, 'w') { |f| f.puts content }
    # Manually place a file with the VMware credentials in #{CACHEDIR}
    vcenter_settings = YAML::load(File.open("#{CACHEDIR}/.vmwarecfg.yml"))
    # Do the thing here
    cputs "Publishing to vSphere"
    sh "/usr/bin/ovftool --noSSLVerify --network='delivery.puppetlabs.net' --datastore='instance1' -o --powerOffTarget --powerOn -n=learn #{VMWAREDIR}/#{$settings[:vmname]}-vmware/#{$settings[:vmname]}/#{$settings[:vmname]}.vmx vi://#{vcenter_settings["username"]}\@puppetlabs.com:#{vcenter_settings["password"]}@vcenter.ops.puppetlabs.net/pdx_office/host/delivery"
  else
    cputs "Skipping - only publish the learning VM"
  end
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
    File.open(path,"wb") do |f|
      begin
        http.request_get(u.path) do |resp|
          resp.read_body do |segment|
            f.write(segment)
          end
        end
      rescue => e
        cputs "Error: #{e.message}"
      end
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

## Prompt for a response if a given ENV variable isn't set.
#
# args:
#   message:  the message you want displayed
#   varname:  the name of the environment variable to look for
#
# usage: update = env_prompt('Increment the release version? [Y/n]: ', 'RELEASE')
def env_prompt(message, varname)
  if ENV.include? varname
    ans = ENV[varname]
  else
    cprint message
    ans = STDIN.gets.strip
  end
  return ans
end

def prompt_del(del=nil)
  del = del || ENV['del']
  loop do
    cprint "Do you want to delete the packaged VMs in #{CACHEDIR}? [no]: "
    del = STDIN.gets.chomp.downcase
    del = 'no' if del.empty?
    puts del
    if del !~ /(y|n|yes|no)/
      cputs "Please answer with yes or no (y/n)."
    else
      break #loop
    end
  end unless del
  if del =~ /(y|yes)/
    $settings[:del] = 'yes'
  else
    $settings[:del] = 'no'
  end
end

def prompt_vmos(osname=nil)
  osname = osname || ENV['vmos']
  loop do
    cprint "Please choose an OS type of 'Centos' or 'Ubuntu' [Centos]: "
    osname = STDIN.gets.chomp
    osname = 'Centos' if osname.empty?
    if osname !~ /(Ubuntu|Centos)/
      cputs "Incorrect/unknown OS: #{osname}"
    else
      break #loop
    end
  end unless osname
  $settings[:vmos] = osname
end

def prompt_vmtype(type=nil)
  type = type || ENV['vmtype']
  loop do
    cprint "Please choose the type of VM - one of 'training' or 'learning' [training]: "
    type = STDIN.gets.chomp
    type = 'training' if type.empty?
    if type !~ /(training|learning)/
      cputs "Incorrect/unknown type of VM: #{type}"
    else
      break #loop
    end
  end unless type
  $settings[:vmtype] = type
end

def build_file(filename)
  template_path = "#{BASEDIR}/files/#{$settings[:vmos]}/#{filename}.erb"
  target_dir = "#{BUILDDIR}/#{$settings[:vmos]}"
  target_path = "#{target_dir}/#{filename}"
  FileUtils.mkdir(target_dir) unless File.directory?(target_dir)
  if File.file?(template_path)
    cputs "Building #{target_path}..."
    File.open(target_path,'w') do |f|
      template_content = ERB.new(File.read(template_path)).result
      f.write(template_content)
    end
  else
    cputs "No source template found: #{template_path}"
  end
end

def map_iso(indev,outdev,paths)
  maps = paths.collect do |frompath,topath|
    "-map '#{frompath}' '#{topath}'"
  end.join(' ')
  system("xorriso -osirrox on -boot_image any patch -indev #{indev} -outdev #{outdev} #{maps}")
end

def verify_download(download, signature)
  crypto = GPGME::Crypto.new
  sign = GPGME::Data.new(File.open(signature))
  file_to_check = GPGME::Data.new(File.open(download))
  crypto.verify(sign, :signed_text => file_to_check, :always_trust => true) do |signature|
   puts "Valid!" if signature.valid?
  end
end

def cputs(string)
  puts "\033[1m#{string}\033[0m"
end

def cprint(string)
  print "\033[1m#{string}\033[0m"
end

# If we want a test version, figure out the latest in the series and download it, otherwise get the release version
def get_pe(pe_install_suffix)
  if PESTATUS =~ /latest/
    perelease=PEVERSION.split('.')
    @real_pe_ver=`curl http://neptune.delivery.puppetlabs.net/#{perelease[0]}.#{perelease[1]}/ci-ready/LATEST`.chomp
  else
    @real_pe_ver=PEVERSION
  end
  cputs "Actual PE version is #{@real_pe_ver}"
  perelease = @real_pe_ver.split('.')
  if PESTATUS =~ /latest/
    url_prefix    = "http://neptune.delivery.puppetlabs.net/#{perelease[0]}.#{perelease[1]}/ci-ready"
    pe_tarball    = "puppet-enterprise-#{@real_pe_ver}#{pe_install_suffix}.tar"
    agent_tarball = "puppet-enterprise-#{@real_pe_ver}#{pe_install_suffix}-agent.tar.gz"
  elsif PESTATUS =~ /release/
    url_prefix    = "https://s3.amazonaws.com/pe-builds/released/#{@real_pe_ver}"
    pe_tarball    = "puppet-enterprise-#{@real_pe_ver}#{pe_install_suffix}.tar.gz"
    agent_tarball = "puppet-enterprise-#{@real_pe_ver}#{pe_install_suffix}-agent.tar.gz"
  else
    abort("Status: #{PESTATUS} not valid - use 'release' or 'latest'.")
  end
  installer       = "#{CACHEDIR}/#{pe_tarball}"
  agent_installer = "#{CACHEDIR}/#{agent_tarball}"
  unless File.exist?(installer)
    cputs "Downloading PE tarball #{@real_pe_ver}..."
    download("#{url_prefix}/#{pe_tarball}", installer)
  end
  unless File.exist?(agent_installer)
    cputs "Downloading PE agent tarball #{@real_pe_ver}..."
    download("#{url_prefix}/#{agent_tarball}", agent_installer)
  end
  if PESTATUS =~ /release/
    unless File.exist?("#{installer}.asc")
      cputs "Downloading PE signature asc file for #{@real_pe_ver}..."
      download "#{url_prefix}/#{pe_tarball}.asc", "#{CACHEDIR}/#{pe_tarball}.asc"
    end
    unless File.exist?("#{agent_installer}.asc")
      cputs "Downloading PE agent signature asc file for #{@real_pe_ver}..."
      download "#{url_prefix}/#{agent_tarball}.asc", "#{CACHEDIR}/#{agent_tarball}.asc"
    end

    cputs "Verifying installer signature"
    raise ('Installer verification failed') unless system("gpg --verify --always-trust #{installer}.asc #{installer}")
    cputs "Verifying agent signature"
    raise ('Agent verification failed') unless  system("gpg --verify --always-trust #{agent_installer}.asc #{agent_installer}")
  end
  return [ pe_tarball, agent_tarball ]
end
# vim: set sw=2 sts=2 et tw=80 :
