require 'erb'
require 'uri'
require 'net/http'
require 'net/https'

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
PEVERSION = '2.7.0'
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

  ['Debian','RedHat'].each do |vmtype|
    case vmtype
    when 'Debian'
      pe_install_suffix = '-debian-6-i386'
    when 'RedHat'
      pe_install_suffix = '-el-6-i386'
    end
    pe_tarball = "puppet-enterprise-#{PEVERSION}#{pe_install_suffix}.tar.gz"
    unless File.exist?("#{CACHEDIR}/#{pe_tarball}")
      cputs "Downloading #{vmtype} PE tarball #{PEVERSION}..."
      download "#{PE_RELEASE_URL}/#{pe_tarball}", "#{CACHEDIR}/#{pe_tarball}"
    end
  end

  cputs "Cloning puppet..."
  gitclone 'git://github.com/puppetlabs/puppet.git', "#{CACHEDIR}/puppet.git", 'master'

  cputs "Cloning facter..."
  gitclone 'git://github.com/puppetlabs/facter.git', "#{CACHEDIR}/facter.git", 'master'

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
task :destroyvm, [:vmtype] do |t,args|
  args.with_defaults(:vmtype => $settings[:vmtype])
  prompt_vmtype(args.vmtype)
  if %x{VBoxManage list vms}.match /("#{$settings[:vmname]}")/
    cputs "Destroying VM #{$settings[:vmname]}..."
    system("VBoxManage unregistervm '#{$settings[:vmname]}' --delete")
  end
end

desc "Create a new vmware instance for kickstarting"
task :createvm, [:vmtype,:mem] do |t,args|
  args.with_defaults(:vmtype => $settings[:vmtype],:mem => (ENV['mem']||'1024'))
  begin
    prompt_vmtype(args.vmtype)
    Rake::Task[:destroyvm].invoke($settings[:vmtype])
    dir = "#{BUILDDIR}/vagrant"
    unless File.directory?(dir)
      FileUtils.mkdir_p(dir)
    end
    cputs "Creating VM '#{$settings[:vmname]}' in #{dir} ..."
    system("VBoxManage createvm --name '#{$settings[:vmname]}' --basefolder '#{dir}' --register --ostype #{$settings[:vmtype]}")
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
task :createiso, [:vmtype] do |t,args|
  args.with_defaults(:vmtype => $settings[:vmtype])
  prompt_vmtype(args.vmtype)
  if ! File.exist?("#{KSISODIR}/#{$settings[:vmtype]}.iso")
    case $settings[:vmtype]
    when 'Debian'
      # Parse templates and output in BUILDDIR
      $settings[:pe_install_suffix] = '-debian-6-i386'
      $settings[:hostname] = "training.puppetlabs.vm"
      $settings[:pe_tarball] = "puppet-enterprise-#{PEVERSION}#{$settings[:pe_install_suffix]}.tar.gz"
      # No variables
      build_file('isolinux.cfg')
      #template_path = "#{BASEDIR}/#{$settings[:vmtype]}/#{filename}.erb"
      # Uses hostname, pe_install_suffix
      build_file('preseed.cfg')

      # Define ISO file targets
      files = {
        "#{BUILDDIR}/Debian/isolinux.cfg"               => '/isolinux/isolinux.cfg',
        "#{BUILDDIR}/Debian/preseed.cfg"                => '/puppet/preseed.cfg',
        "#{CACHEDIR}/puppet.git"                        => '/puppet/puppet.git',
        "#{CACHEDIR}/facter.git"                        => '/puppet/facter.git',
        "#{CACHEDIR}/puppetlabs-training-bootstrap.git" => '/puppet/puppetlabs-training-bootstrap.git',
        "#{CACHEDIR}/#{$settings[:pe_tarball]}"                     => "/puppet/#{$settings[:pe_tarball]}",
      }
      iso_glob = 'debian-*'
      iso_url = 'http://hammurabi.acc.umu.se/debian-cd/6.0.6/i386/iso-cd/debian-6.0.6-i386-CD-1.iso'
    when 'RedHat'
      # Parse templates and output in BUILDDIR
      $settings[:pe_install_suffix] = '-el-6-i386'
      $settings[:hostname] = "training.puppetlabs.vm"
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

      # Define ISO file targets
      files = {
        "#{BUILDDIR}/RedHat/isolinux.cfg"               => '/isolinux/isolinux.cfg',
        "#{BUILDDIR}/RedHat/ks.cfg"                     => '/puppet/ks.cfg',
        "#{CACHEDIR}/epel-release.rpm"                  => '/puppet/epel-release.rpm',
        "#{CACHEDIR}/puppet.git"                        => '/puppet/puppet.git',
        "#{CACHEDIR}/facter.git"                        => '/puppet/facter.git',
        "#{CACHEDIR}/puppetlabs-training-bootstrap.git" => '/puppet/puppetlabs-training-bootstrap.git',
        "#{CACHEDIR}/#{$settings[:pe_tarball]}"                     => "/puppet/#{$settings[:pe_tarball]}",
      }
      iso_glob = 'CentOS-*'
      iso_url = 'http://mirror.tocici.com/centos/6.3/isos/i386/CentOS-6.3-i386-bin-DVD1.iso'
    end
    iso_file = Dir.glob("#{CACHEDIR}/#{iso_glob}").first
    if ! iso_file
      iso_default = iso_url
    else
      iso_default = iso_file
    end
    cprint "Please specify #{$settings[:vmtype]} ISO path or url [#{iso_default}]: "
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
    map_iso(iso_file, "#{KSISODIR}/#{$settings[:vmtype]}.iso", files)
  else
    cputs "Image #{KSISODIR}/#{$settings[:vmtype]}.iso is already created; skipping"
  end
end

task :mountiso, [:vmtype] => [:createiso] do |t,args|
  args.with_defaults(:vmtype => $settings[:vmtype])
  prompt_vmtype(args.vmtype)
  cputs "Mounting #{$settings[:vmtype]} on #{$settings[:vmname]}"
  system("VBoxManage storageattach '#{$settings[:vmname]}' --storagectl 'IDE Controller' --port 1 --device 0 --type dvddrive --medium '#{KSISODIR}/#{$settings[:vmtype]}.iso'")
  Rake::Task[:unmountiso].reenable
end

task :unmountiso, [:vmtype] do |t,args|
  args.with_defaults(:vmtype => $settings[:vmtype])
  prompt_vmtype(args.vmtype)

  sleeptotal = 0
  while %x{VBoxManage list runningvms}.match /("#{$settings[:vmname]}")/
    cputs "Waiting for #{$settings[:vmname]} to shut down before unmounting..." if sleeptotal >= 90
    sleep 5
    sleeptotal += 5
  end
  cputs "Unmounting #{$settings[:vmtype]} on #{$settings[:vmname]}"
  system("VBoxManage storageattach '#{$settings[:vmname]}' --storagectl 'IDE Controller' --port 1 --device 0 --type dvddrive --medium none")
  Rake::Task[:mountiso].reenable
end

desc "Remove the dynamically created ISO"
task :destroyiso, [:vmtype] do |t,args|
  args.with_defaults(:vmtype => $settings[:vmtype])
  prompt_vmtype(args.vmtype)

  if File.exists?("#{KSISODIR}/#{$settings[:vmtype]}.iso")
    cputs "Removing ISO..."
    File.delete("#{KSISODIR}/#{$settings[:vmtype]}.iso")
  else
    cputs "No ISO found"
  end
end

desc "Start the VM"
task :startvm, [:vmtype] do |t,args|
  args.with_defaults(:vmtype => $settings[:vmtype])
  prompt_vmtype(args.vmtype)

  cputs "Starting #{$settings[:vmname]}"
  system("VBoxManage startvm '#{$settings[:vmname]}'")
end

desc "Reload the VM"
task :reloadvm, [:vmtype] => [:createvm, :mountiso, :startvm] do |t,args|
  args.with_defaults(:vmtype => $settings[:vmtype])
  prompt_vmtype(args.vmtype)
  Rake::Task[:unmountiso].invoke($settings[:vmtype])
end

desc "Do everything!"
task :everything, [:vmtype] do |t,args|
  args.with_defaults(:vmtype => $settings[:vmtype])
  prompt_vmtype(args.vmtype)

  Rake::Task[:init].invoke
  Rake::Task[:createvm].invoke($settings[:vmtype])
  Rake::Task[:createiso].invoke($settings[:vmtype])
  Rake::Task[:mountiso].invoke($settings[:vmtype])
  Rake::Task[:startvm].invoke($settings[:vmtype])
  Rake::Task[:unmountiso].invoke($settings[:vmtype])
  Rake::Task[:createovf].invoke($settings[:vmtype])
  Rake::Task[:createvmx].invoke($settings[:vmtype])
  Rake::Task[:createvbox].invoke($settings[:vmtype])
  Rake::Task[:vagrantize].invoke($settings[:vmtype])
  Rake::Task[:packagevm].invoke($settings[:vmtype])
end

desc "Force-stop the VM"
task :stopvm, [:vmtype] do |t,args|
  args.with_defaults(:vmtype => $settings[:vmtype])
  prompt_vmtype(args.vmtype)
  if %x{VBoxManage list runningvms}.match /("#{$settings[:vmname]}")/
    cputs "Stopping #{$settings[:vmname]}"
    system("VBoxManage controlvm '#{$settings[:vmname]}' poweroff")
  end
end

task :createovf, [:vmtype] do |t,args|
  args.with_defaults(:vmtype => $settings[:vmtype])
  prompt_vmtype(args.vmtype)

  Rake::Task[:unmountiso].invoke($settings[:vmtype])
  cputs "Converting Original .vbox to OVF..."
  FileUtils.rm_rf("#{OVFDIR}/#{$settings[:vmname]}-ovf") if File.directory?("#{OVFDIR}/#{$settings[:vmname]}-ovf")
  FileUtils.mkdir_p("#{OVFDIR}/#{$settings[:vmname]}-ovf")
  system("VBoxManage export '#{$settings[:vmname]}' -o '#{OVFDIR}/#{$settings[:vmname]}-ovf/#{$settings[:vmname]}.ovf'")
end

task :createvmx, [:vmtype] => [:createovf] do |t,args|
  args.with_defaults(:vmtype => $settings[:vmtype])
  prompt_vmtype(args.vmtype)
  ovftool_default = '/Applications/VMware OVF Tool/ovftool' #XXX Dynamicize this

  Rake::Task[:unmountiso].invoke($settings[:vmtype])
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

task :createvbox, [:vmtype] do |t,args|
  args.with_defaults(:vmtype => $settings[:vmtype])
  prompt_vmtype(args.vmtype)

  ovftool_default = '/Applications/VMware OVF Tool/ovftool' #XXX Dynamicize this
  cputs "Making copy of VM for VBOX..."
  FileUtils.rm_rf("#{VBOXDIR}/#{$settings[:vmname]}-vbox") if File.directory?("#{VBOXDIR}/#{$settings[:vmname]}-vbox")
  FileUtils.mkdir_p("#{VBOXDIR}/#{$settings[:vmname]}-vbox")
  system("rsync -a '#{VAGRANTDIR}/#{$settings[:vmname]}/' '#{VBOXDIR}/#{$settings[:vmname]}-vbox'")
end

task :vagrantize, [:vmtype] do |t,args|
  cputs "Vagrantizing VM not yet implemented"
end

desc "Zip up the VMs (unimplemented)"
task :packagevm, [:vmtype] do |t,args|
  args.with_defaults(:vmtype => $settings[:vmtype])
  prompt_vmtype(args.vmtype)

  system("zip -rj '#{CACHEDIR}/#{$settings[:vmname]}-ovf.zip' '#{OVFDIR}/#{$settings[:vmname]}-ovf'")
  system("zip -rj '#{CACHEDIR}/#{$settings[:vmname]}-vmware.zip' '#{VMWAREDIR}/#{$settings[:vmname]}-vmware'")
  system("zip -rj '#{CACHEDIR}/#{$settings[:vmname]}-vbox.zip' '#{VBOXDIR}/#{$settings[:vmname]}-vbox'")
  system("md5 '#{CACHEDIR}/#{$settings[:vmname]}-ovf.zip' > '#{CACHEDIR}/#{$settings[:vmname]}-ovf.zip.md5'")
  system("md5 '#{CACHEDIR}/#{$settings[:vmname]}-vmware.zip' > '#{CACHEDIR}/#{$settings[:vmname]}-vmware.zip.md5'")
  system("md5 '#{CACHEDIR}/#{$settings[:vmname]}-vbox.zip' > '#{CACHEDIR}/#{$settings[:vmname]}-vbox.zip.md5'")
  # zip & md5 vagrant
end

desc "Unmount the ISO and remove kickstart files and repos"
task :clean do
  cputs "Destroying vms"
  ['Debian','RedHat'].each do |os|
    Rake::Task[:destroyvm].invoke(os)
    Rake::Task[:destroyvm].reenable
  end
  cputs "Removing #{BUILDDIR}"
  FileUtils.rm_rf(BUILDDIR) if File.directory?(BUILDDIR)
  #FileUtils.rm_rf(KSISODIR) if File.directory?(KSISODIR)
  #FileUtils.rm_rf(VAGRANTDIR) if File.directory?(VAGRANTDIR)
  #FileUtils.rm_rf(VMWAREDIR) if File.directory?(VMWAREDIR)
  #FileUtils.rm_rf(OVFDIR) if File.directory?(OVFDIR)
  #FileUtils.rm_rf(VBOXDIR) if File.directory?(VBOXDIR)
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

def prompt_vmtype(type=nil)
  type = type || ENV['vmtype']
  loop do
    cprint "Please choose an OS type of 'RedHat' or 'Debian' [RedHat]: "
    type = STDIN.gets.chomp
    type = 'RedHat' if type.empty?
    if type !~ /(Debian|RedHat)/
      cputs "Incorrect/unknown OS type: #{type}"
    else
      break #loop
    end
  end unless type
  $settings[:vmtype] = type
  $settings[:vmname] = "Puppet #{type}"
end

def build_file(filename)
  template_path = "#{BASEDIR}/files/#{$settings[:vmtype]}/#{filename}.erb"
  target_dir = "#{BUILDDIR}/#{$settings[:vmtype]}"
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

def cputs(string)
  puts "\033[1m#{string}\033[0m"
end

def cprint(string)
  print "\033[1m#{string}\033[0m"
end
# vim: set sw=2 sts=2 et tw=80 :
