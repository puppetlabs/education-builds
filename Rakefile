require 'erb'
require 'uri'
require 'net/http'
require 'net/https'
require 'rubygems'
require 'gpgme'

STDOUT.sync = true
BASEDIR = File.dirname(__FILE__)
SITESDIR = ENV['HOME'] + "/Sites"
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
PEVERSION = '3.1.0'
PE_RELEASE_URL = "https://s3.amazonaws.com/pe-builds/released/#{PEVERSION}"
$settings = Hash.new

desc "Build and populate data directory"
task :init do
  [BUILDDIR, KSISODIR, CACHEDIR].each do |dir|
    unless File.directory?(dir)
      cputs "Making #{dir} for all kickstart data"
      FileUtils.mkdir_p(dir)
    end
  end

  ['Debian','Centos'].each do |vmos|
    case vmos
    when 'Debian'
      pe_install_suffix = '-debian-6-i386'
    when 'Centos'
      pe_install_suffix = '-el-6-i386'
    end
    pe_tarball = "puppet-enterprise-#{PEVERSION}#{pe_install_suffix}.tar.gz"
    installer = "#{CACHEDIR}/#{pe_tarball}"
    unless File.exist?(installer)
      cputs "Downloading #{vmos} PE tarball #{PEVERSION}..."
      download "#{PE_RELEASE_URL}/#{pe_tarball}", installer
    end
    unless File.exist?("#{installer}.asc")
      cputs "Downloading #{vmos} PE signature asc file for #{PEVERSION}..."
      download "#{PE_RELEASE_URL}/#{pe_tarball}.asc", "#{CACHEDIR}/#{pe_tarball}.asc"
    end
    cputs "Verifying signature"
    system("gpg --verify --always-trust #{installer}.asc #{installer}")
    puts $?
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
end

desc "Destroy VirtualBox instance"
task :destroyvm, [:vmos] do |t,args|
  args.with_defaults(:vmos => $settings[:vmos])
  prompt_vmos(args.vmos)
  if %x{VBoxManage list vms}.match /("#{$settings[:vmname]}")/
    cputs "Destroying VM #{$settings[:vmname]}..."
    system("VBoxManage unregistervm '#{$settings[:vmname]}' --delete")
  end
end

desc "Create a new vmware instance for kickstarting"
task :createvm, [:vmos,:vmtype,:mem] do |t,args|
  args.with_defaults(:vmos => $settings[:vmos],:vmtype => $settings[:vmtype],:mem => (ENV['mem']||'1024'))
  begin
    prompt_vmos(args.vmos)

    Rake::Task[:destroyvm].invoke($settings[:vmos])
    dir = "#{BUILDDIR}/vagrant"
    unless File.directory?(dir)
      FileUtils.mkdir_p(dir)
    end

    case $settings[:vmos]
    when /(Centos|Redhat)/
      ostype = 'RedHat'
    end
    cputs "Creating VM '#{$settings[:vmname]}' in #{dir} ..."
    system("VBoxManage createvm --name '#{$settings[:vmname]}' --basefolder '#{dir}' --register --ostype #{ostype}")
    Dir.chdir("#{dir}/#{$settings[:vmname]}")
    cputs "Configuring VM settings..."
    system("VBoxManage modifyvm '#{$settings[:vmname]}' --memory #{args.mem} --nic1 nat --usb off --audio none")
    system("VBoxManage storagectl '#{$settings[:vmname]}' --name 'IDE Controller' --add ide")
    system("VBoxManage createhd --filename 'box-disk1.vmdk' --size 8192 --format VMDK")
    system("VBoxManage storageattach '#{$settings[:vmname]}' --storagectl 'IDE Controller' --port 0 --device 0 --type hdd --medium 'box-disk1.vmdk'")
    system("VBoxManage storageattach '#{$settings[:vmname]}' --storagectl 'IDE Controller' --port 1 --device 0 --type dvddrive --medium emptydrive")
  ensure
    Dir.chdir(BASEDIR)
  end
end

desc "Creates a modified ISO with preseed/kickstart"
task :createiso, [:vmos,:vmtype] do |t,args|
  args.with_defaults(:vmos => $settings[:vmos], :vmtype => $settings[:vmtype])
  prompt_vmos(args.vmos)
  prompt_vmtype(args.vmtype)
  case $settings[:vmos]
  when 'Debian'
    # Parse templates and output in BUILDDIR
    $settings[:pe_install_suffix] = '-debian-6-i386'
    if $settings[:vmtype] == 'training'
      $settings[:hostname] = "#{$settings[:vmtype]}.puppetlabs.vm"
    else
      $settings[:hostname] = "learn.localdomain"
    end
    $settings[:pe_tarball] = "puppet-enterprise-#{PEVERSION}#{$settings[:pe_install_suffix]}.tar.gz"
    # No variables
    build_file('isolinux.cfg')
    #template_path = "#{BASEDIR}/#{$settings[:vmos]}/#{filename}.erb"
    # Uses hostname, pe_install_suffix
    build_file('preseed.cfg')

    # Define ISO file targets
    files = {
      "#{BUILDDIR}/Debian/isolinux.cfg"               => '/isolinux/isolinux.cfg',
      "#{BUILDDIR}/Debian/preseed.cfg"                => '/puppet/preseed.cfg',
      "#{CACHEDIR}/puppet.git"                        => '/puppet/puppet.git',
      "#{CACHEDIR}/facter.git"                        => '/puppet/facter.git',
      "#{CACHEDIR}/hiera.git"                         => '/puppet/hiera.git',
      "#{CACHEDIR}/puppetlabs-training-bootstrap.git" => '/puppet/puppetlabs-training-bootstrap.git',
      "#{CACHEDIR}/#{$settings[:pe_tarball]}"                     => "/puppet/#{$settings[:pe_tarball]}",
    }
    iso_glob = 'debian-*'
    iso_url = 'http://mirror.tocici.com/centos/6/isos/i386/CentOS-6.4-i386-bin-DVD1.iso'
  when 'Centos'
    # Parse templates and output in BUILDDIR
    $settings[:pe_install_suffix] = '-el-6-i386'
    if $settings[:vmtype] == 'training'
      $settings[:hostname] = "#{$settings[:vmtype]}.puppetlabs.vm"
    else
      $settings[:hostname] = "learn.localdomain"
    end

    $settings[:pe_tarball] = "puppet-enterprise-#{PEVERSION}#{$settings[:pe_install_suffix]}.tar.gz"
    # No variables
    build_file('isolinux.cfg')
    # Uses hostname, pe_install_suffix
    build_file('ks.cfg')

    unless File.exist?("#{CACHEDIR}/epel-release.rpm")
      cputs "Downloading EPEL rpm"
      #download "http://mirrors.cat.pdx.edu/epel/5/i386/epel-release-5-4.noarch.rpm", "#{CACHEDIR}/epel-release.rpm"
      download "http://mirrors.cat.pdx.edu/epel/6/i386/epel-release-6-8.noarch.rpm", "#{CACHEDIR}/epel-release.rpm"
    end
    
    unless File.exist?("#{CACHEDIR}/puppetlabs-enterprise-release-extras.rpm")
      cputs "Downloading Puppet Enterprise Extras rpm"
      #download "http://mirrors.cat.pdx.edu/epel/5/i386/epel-release-5-4.noarch.rpm", "#{CACHEDIR}/epel-release.rpm"
    download "http://yum-enterprise.puppetlabs.com/el/6/extras/i386/puppetlabs-enterprise-release-extras-6-2.noarch.rpm", "#{CACHEDIR}/puppetlabs-enterprise-release-extras.rpm"
    end

    # Define ISO file targets
    files = {
      "#{BUILDDIR}/Centos/isolinux.cfg"               => '/isolinux/isolinux.cfg',
      "#{BUILDDIR}/Centos/ks.cfg"                     => '/puppet/ks.cfg',
      "#{CACHEDIR}/epel-release.rpm"                  => '/puppet/epel-release.rpm',
      "#{CACHEDIR}/puppetlabs-enterprise-release-extras.rpm"  => '/puppet/puppetlabs-enterprise-release-extras.rpm',
      "#{CACHEDIR}/puppet.git"                        => '/puppet/puppet.git',
      "#{CACHEDIR}/facter.git"                        => '/puppet/facter.git',
      "#{CACHEDIR}/hiera.git"                        => '/puppet/hiera.git',
      "#{CACHEDIR}/puppetlabs-training-bootstrap.git" => '/puppet/puppetlabs-training-bootstrap.git',
      "#{CACHEDIR}/#{$settings[:pe_tarball]}"                     => "/puppet/#{$settings[:pe_tarball]}",
    }
    iso_glob = 'CentOS-*'
    iso_url = 'http://mirror.chpc.utah.edu/pub/centos/6.4/isos/i386/CentOS-6.4-i386-bin-DVD1.iso'
  end


  iso_file = Dir.glob("#{CACHEDIR}/#{iso_glob}").first

  if ! iso_file
    iso_default = iso_url
  else
    iso_default = iso_file
  end
  if ! File.exist?("#{KSISODIR}/#{$settings[:vmos]}.iso")
    cprint "Please specify #{$settings[:vmos]} ISO path or url [#{iso_default}]: "
    iso_uri = STDIN.gets.chomp.rstrip
    iso_uri = iso_default if iso_uri.empty?
    if iso_uri != iso_file
      case iso_uri
      when /^(http|https):\/\//
        iso_file = File.basename(iso_uri)
        cputs "Downloading ISO to #{CACHEDIR}/#{iso_file}..."
        download iso_uri, "#{CACHEDIR}/#{iso_file}"
      else
        cputs "Copying ISO to #{CACHEDIR}..."
        FileUtils.cp iso_uri, CACHEDIR
      end
      iso_file = Dir.glob("#{CACHEDIR}/#{iso_glob}").first
    end
    cputs "Mapping files from #{BUILDDIR} into ISO..."
    map_iso(iso_file, "#{KSISODIR}/#{$settings[:vmos]}.iso", files)
  else
    cputs "Image #{KSISODIR}/#{$settings[:vmos]}.iso is already created; skipping"
  end
  # Extract the OS version from the iso filename as debian and centos are the
  # same basic format and get caught by the match group below
  iso_version = iso_url[/^.*-(\d+\.\d\.?\d?)-.*\.iso$/,1]
  if $settings[:vmtype] == 'training'
    $settings[:vmname] = "#{$settings[:vmos]}-#{iso_version}-pe-#{PEVERSION}".downcase
  else
    $settings[:vmname] = "learn_puppet_#{$settings[:vmos]}-#{iso_version}-pe-#{PEVERSION}".downcase
  end
end

task :mountiso, [:vmos] => [:createiso] do |t,args|
  args.with_defaults(:vmos => $settings[:vmos])
  prompt_vmos(args.vmos)
  cputs "Mounting #{$settings[:vmos]} on #{$settings[:vmname]}"
  system("VBoxManage storageattach '#{$settings[:vmname]}' --storagectl 'IDE Controller' --port 1 --device 0 --type dvddrive --medium '#{KSISODIR}/#{$settings[:vmos]}.iso'")
  Rake::Task[:unmountiso].reenable
end

task :unmountiso, [:vmos] do |t,args|
  args.with_defaults(:vmos => $settings[:vmos])
  prompt_vmos(args.vmos)

  sleeptotal = 0
  while %x{VBoxManage list runningvms}.match /("#{$settings[:vmname]}")/
    cputs "Waiting for #{$settings[:vmname]} to shut down before unmounting..." if sleeptotal >= 90
    sleep 5
    sleeptotal += 5
  end
  cputs "Unmounting #{$settings[:vmos]} on #{$settings[:vmname]}"
  system("VBoxManage storageattach '#{$settings[:vmname]}' --storagectl 'IDE Controller' --port 1 --device 0 --type dvddrive --medium none")
  Rake::Task[:mountiso].reenable
end

desc "Remove the dynamically created ISO"
task :destroyiso, [:vmos] do |t,args|
  args.with_defaults(:vmos => $settings[:vmos])
  prompt_vmos(args.vmos)

  if File.exists?("#{KSISODIR}/#{$settings[:vmos]}.iso")
    cputs "Removing ISO..."
    File.delete("#{KSISODIR}/#{$settings[:vmos]}.iso")
  else
    cputs "No ISO found"
  end
end

desc "Start the VM"
task :startvm, [:vmos] do |t,args|
  args.with_defaults(:vmos => $settings[:vmos])
  prompt_vmos(args.vmos)

  cputs "Starting #{$settings[:vmname]}"
  system("VBoxManage startvm '#{$settings[:vmname]}'")
end

desc "Reload the VM"
task :reloadvm, [:vmos] => [:createvm, :mountiso, :startvm] do |t,args|
  args.with_defaults(:vmos => $settings[:vmos])
  prompt_vmos(args.vmos)
  Rake::Task[:unmountiso].invoke($settings[:vmos])
end

desc "Do everything!"
task :everything, [:vmos] do |t,args|
  args.with_defaults(:vmos => $settings[:vmos])
  prompt_vmos(args.vmos)

  Rake::Task[:init].invoke
  Rake::Task[:createiso].invoke($settings[:vmos])
  Rake::Task[:createvm].invoke($settings[:vmos])
  Rake::Task[:mountiso].invoke($settings[:vmos])
  Rake::Task[:startvm].invoke($settings[:vmos])
  Rake::Task[:unmountiso].invoke($settings[:vmos])
  Rake::Task[:createovf].invoke($settings[:vmos])
  Rake::Task[:createvmx].invoke($settings[:vmos])
  Rake::Task[:createvbox].invoke($settings[:vmos])
  Rake::Task[:vagrantize].invoke($settings[:vmos])
  Rake::Task[:packagevm].invoke($settings[:vmos])
end

desc "Force-stop the VM"
task :stopvm, [:vmos] do |t,args|
  args.with_defaults(:vmos => $settings[:vmos])
  prompt_vmos(args.vmos)
  if %x{VBoxManage list runningvms}.match /("#{$settings[:vmname]}")/
    cputs "Stopping #{$settings[:vmname]}"
    system("VBoxManage controlvm '#{$settings[:vmname]}' poweroff")
  end
end

task :createovf, [:vmos] do |t,args|
  args.with_defaults(:vmos => $settings[:vmos])
  prompt_vmos(args.vmos)

  Rake::Task[:unmountiso].invoke($settings[:vmos])
  cputs "Converting Original .vbox to OVF..."
  FileUtils.rm_rf("#{OVFDIR}/#{$settings[:vmname]}-ovf") if File.directory?("#{OVFDIR}/#{$settings[:vmname]}-ovf")
  FileUtils.mkdir_p("#{OVFDIR}/#{$settings[:vmname]}-ovf")
  system("VBoxManage export '#{$settings[:vmname]}' -o '#{OVFDIR}/#{$settings[:vmname]}-ovf/#{$settings[:vmname]}.ovf'")
end

task :createvmx, [:vmos] => [:createovf] do |t,args|
  args.with_defaults(:vmos => $settings[:vmos])
  prompt_vmos(args.vmos)
  ovftool_default = '/Applications/VMware OVF Tool/ovftool' #XXX Dynamicize this

  Rake::Task[:unmountiso].invoke($settings[:vmos])
  cputs "Converting OVF to VMX..."
  FileUtils.rm_rf("#{VMWAREDIR}/#{$settings[:vmname]}-vmware") if File.directory?("#{VMWAREDIR}/#{$settings[:vmname]}-vmware")
  FileUtils.mkdir_p("#{VMWAREDIR}/#{$settings[:vmname]}-vmware")
  system("'#{ovftool_default}' --lax --compress=9 --targetType=VMX '#{OVFDIR}/#{$settings[:vmname]}-ovf/#{$settings[:vmname]}.ovf' '#{VMWAREDIR}/#{$settings[:vmname]}-vmware'")

  cputs 'Changing virtualhw.version = "9" to "8"'
  vmxpath = "#{VMWAREDIR}/#{$settings[:vmname]}-vmware/#{$settings[:vmname]}.vmwarevm/#{$settings[:vmname]}.vmx"
  content = File.read(vmxpath)
  content = content.gsub(/^virtualhw\.version = "9"$/, 'virtualhw.version = "8"')
  File.open(vmxpath, 'w') { |f| f.puts content }
end

task :createvbox, [:vmos] do |t,args|
  args.with_defaults(:vmos => $settings[:vmos])
  prompt_vmos(args.vmos)

  ovftool_default = '/Applications/VMware OVF Tool/ovftool' #XXX Dynamicize this
  cputs "Making copy of VM for VBOX..."
  FileUtils.rm_rf("#{VBOXDIR}/#{$settings[:vmname]}-vbox") if File.directory?("#{VBOXDIR}/#{$settings[:vmname]}-vbox")
  FileUtils.mkdir_p("#{VBOXDIR}/#{$settings[:vmname]}-vbox")
  system("rsync -a '#{VAGRANTDIR}/#{$settings[:vmname]}/' '#{VBOXDIR}/#{$settings[:vmname]}-vbox'")
end

task :vagrantize, [:vmos] do |t,args|
  args.with_defaults(:vmos => $settings[:vmos])
  prompt_vmos(args.vmos)

  cputs "Vagrantizing VM..."
  system("vagrant package --base '#{$settings[:vmname]}' --output '#{VAGRANTDIR}/#{$settings[:vmname]}.box'")
  FileUtils.ln_sf("#{VAGRANTDIR}/#{$settings[:vmname]}.box", "#{VAGRANTDIR}/#{$settings[:vmos].downcase}-latest.box")
end

desc "Zip up the VMs (unimplemented)"
task :packagevm, [:vmos] do |t,args|
  args.with_defaults(:vmos => $settings[:vmos])
  prompt_vmos(args.vmos)

  system("zip -rj '#{CACHEDIR}/#{$settings[:vmname]}-ovf.zip' '#{OVFDIR}/#{$settings[:vmname]}-ovf'")
  system("zip -rj '#{CACHEDIR}/#{$settings[:vmname]}-vmware.zip' '#{VMWAREDIR}/#{$settings[:vmname]}-vmware'")
  system("zip -rj '#{CACHEDIR}/#{$settings[:vmname]}-vbox.zip' '#{VBOXDIR}/#{$settings[:vmname]}-vbox'")
  system("md5 '#{CACHEDIR}/#{$settings[:vmname]}-ovf.zip' > '#{CACHEDIR}/#{$settings[:vmname]}-ovf.zip.md5'")
  system("md5 '#{CACHEDIR}/#{$settings[:vmname]}-vmware.zip' > '#{CACHEDIR}/#{$settings[:vmname]}-vmware.zip.md5'")
  system("md5 '#{CACHEDIR}/#{$settings[:vmname]}-vbox.zip' > '#{CACHEDIR}/#{$settings[:vmname]}-vbox.zip.md5'")
  # zip & md5 vagrant
end

desc "Unmount the ISO and remove kickstart files and repos"
task :clean, [:del] do |t,args|
  args.with_defaults(:del => $settings[:del])
  prompt_del(args.del)

  cputs "Destroying vms"
  ['Debian','Centos'].each do |os|
    Rake::Task[:destroyvm].invoke(os)
    Rake::Task[:destroyvm].reenable
  end
  cputs "Removing #{BUILDDIR}"
  FileUtils.rm_rf(BUILDDIR) if File.directory?(BUILDDIR)
  if $settings[:del] == 'yes'
    cputs "Removing packaged VMs"
    FileUtils.rm Dir.glob("#{CACHEDIR}/*-pe-#{PEVERSION}*.zip*")
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
    cprint "Please choose an OS type of 'Centos' or 'Debian' [Centos]: "
    osname = STDIN.gets.chomp
    osname = 'Centos' if osname.empty?
    if osname !~ /(Debian|Centos)/
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
# vim: set sw=2 sts=2 et tw=80 :
