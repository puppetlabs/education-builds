require 'erb'
require 'uri'
require 'net/http'
require 'net/https'
require 'rubygems'
require 'yaml'

STDOUT.sync = true
BASEDIR = File.dirname(__FILE__)
PEVERSION = ENV['PEVERSION'] || '3.8.0'
PESTATUS = ENV['PESTATUS'] || 'release'
PEURL = ENV['PEURL'] || 'https://pm.puppetlabs.com/cgi-bin/download.cgi?dist=el&rel=7&arch=x86_64&ver=latest'
SRCDIR = ENV['SRCDIR'] || '/usr/src'
PUPPET_VER = '4.3.1'
FACTER_VER = '3.1.2'
HIERA_VER = '3.0.5'
VMTYPE = ENV['VMTYPE'] || 'training'
PTBVERSION = YAML.load_file('version.yaml')

## These are used by the shipping tasks
SITESDIR = "/srv/builder/Sites" || ENV["SITESDIR"]
CACHEDIR = File.join(SITESDIR, "cache")
BUILDDIR = File.join(SITESDIR, "build")
OVFDIR = File.join(BUILDDIR, "ovf")

$settings = Hash.new

hostos = `uname -s`

# Bail if handed a 'VMTYPE' that's not supported.
if VMTYPE !~ /^(training|learning|student)$/
  abort("ERROR: Unrecognized VMTYPE parameter: #{VMTYPE}")
end

desc "Print list of rake tasks"
task :default do
  system("rake -sT")  # s for silent
  cputs "NOTE: The usage of this Rakefile has changed.\n" + \
        "This is intended to be run within a blank VM to bootstrap it to the various Education VMs.\n" + \
        "To use this repo to provision a VM, refer to the files in the packer directory.\n"
end

desc "Install puppet-agent for VM deployment"
task :standalone_puppet_agent do

  if File.read('/etc/redhat-release') =~ /release 6/ then
    cputs "Adding CentOS 6 yum repo"
    %x{rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-6.noarch.rpm}
  else
    cputs "Adding CentOS 7 yum repo"
    %x{rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm}
  end

  %x{yum -y install puppet-agent}

  STDOUT.sync = true
  STDOUT.flush
end

desc "Install PE Master"
task :install_pe do
  if not File.exist?('/tmp/puppet-enterprise.tar.gz')
    %x{curl -o /tmp/puppet-enterprise.tar.gz -L #{PEURL}}
  end
  %x{tar xf /tmp/puppet-enterprise.tar.gz}
  %x{/tmp/puppet-enterprise/puppet-enterprise-installer -D -a /usr/src/puppetlabs-training-bootstrap/files/answers}
end

desc "Training VM pre-install setup"
task :training_pre do
  VMTYPE='training'
  # Set the dns info and hostname; must be done before puppet
  cputs "Setting hostname training.puppetlabs.vm"
  %x{hostname training.puppetlabs.vm}
  cputs  "Editing /etc/hosts"
  %x{sed -i "s/127\.0\.0\.1.*/127.0.0.1 training.puppetlabs.vm training localhost localhost.localdomain localhost4/" /etc/hosts}
  cputs "Editing /etc/sysconfig/network"
  %x{sed -ie "s/HOSTNAME.*/HOSTNAME=training.puppetlabs.vm/" /etc/sysconfig/network}
  %x{printf '\nsupersede domain-search "puppetlabs.vm";\n' >> /etc/dhcp/dhclient-eth0.conf}
  # Include /etc/hostname for centos7+
  File.open('/etc/hostname', 'w') { |file| file.write("training.puppetlabs.vm") }

end
desc "Learning VM pre-install setup"
task :learning_pre do
  VMTYPE='learning'
  # Set the dns info and hostname; must be done before puppet
  cputs "Setting hostname learning.puppetlabs.vm"
  %x{hostname learning.puppetlabs.vm}
  cputs  "Editing /etc/hosts"
  %x{sed -i "s/127\.0\.0\.1.*/127.0.0.1 learning.puppetlabs.vm localhost localhost.localdomain localhost4/" /etc/hosts}
  cputs "Editing /etc/sysconfig/network"
  %x{sed -ie "s/HOSTNAME.*/HOSTNAME=learning.puppetlabs.vm/" /etc/sysconfig/network}
  %x{printf '\nsupersede domain-search "puppetlabs.vm";\n' >> /etc/dhcp/dhclient-eth0.conf}
  # Include /etc/hostname for centos7+
  File.open('/etc/hostname', 'w') { |file| file.write("learning.puppetlabs.vm") }

end

desc "Student VM pre-install setup"
task :student_pre do
  VMTYPE='student'
  # Set the dns info and hostname; must be done before puppet
  cputs "Setting hostname student.puppetlabs.vm"
  %x{hostname student.puppetlabs.vm}
  cputs  "Editing /etc/hosts"
  %x{sed -i "s/127\.0\.0\.1.*/127.0.0.1 student.puppetlabs.vm training localhost localhost.localdomain localhost4/" /etc/hosts}
  cputs "Editing /etc/sysconfig/network"
  %x{sed -ie "s/HOSTNAME.*/HOSTNAME=student.puppetlabs.vm/" /etc/sysconfig/network}
  %x{printf '\nsupersede domain-search "puppetlabs.vm";\n' >> /etc/dhcp/dhclient-eth0.conf}
  # Include /etc/hostname for centos7+
  File.open('/etc/hostname', 'w') { |file| file.write("student.puppetlabs.vm") }
end

desc "Master VM pre-install setup"
task :master_pre do
  VMTYPE='master'
  # Set the dns info and hostname; must be done before puppet
  cputs "Setting hostname master.puppetlabs.vm"
  %x{hostname master.puppetlabs.vm}
  cputs  "Editing /etc/hosts"
  %x{sed -i "s/127\.0\.0\.1.*/127.0.0.1 master.puppetlabs.vm master localhost localhost.localdomain localhost4/" /etc/hosts}
  cputs "Editing /etc/sysconfig/network"
  %x{sed -ie "s/HOSTNAME.*/HOSTNAME=master.puppetlabs.vm/" /etc/sysconfig/network}
  %x{printf '\nsupersede domain-search "puppetlabs.vm";\n' >> /etc/dhcp/dhclient-eth0.conf}
  # Include /etc/hostname for centos7+
  File.open('/etc/hostname', 'w') { |file| file.write("master.puppetlabs.vm") }
end

desc "LMS VM pre-install setup"
task :lms_pre do
  VMTYPE='lms'
  # Set the dns info and hostname; must be done before puppet
  cputs "Setting hostname lms.puppetlabs.vm"
  %x{hostname lms.puppetlabs.vm}
  cputs  "Editing /etc/hosts"
  %x{sed -i "s/127\.0\.0\.1.*/127.0.0.1 lms.puppetlabs.vm localhost localhost.localdomain localhost4/" /etc/hosts}
  cputs "Editing /etc/sysconfig/network"
  %x{sed -ie "s/HOSTNAME.*/HOSTNAME=lms.puppetlabs.vm/" /etc/sysconfig/network}
  %x{printf '\nsupersede domain-search "puppetlabs.vm";\n' >> /etc/dhcp/dhclient-eth0.conf}
  # Include /etc/hostname for centos7+
  File.open('/etc/hostname', 'w') { |file| file.write("lms.puppetlabs.vm") }
end

desc "Apply bootstrap manifest"
task :build do
 cputs "Installing R10k"
 system('PATH=$PATH:/opt/puppetlabs/puppet/bin:/usr/local/bin gem install r10k -v 1.5.1 --no-RI --no-RDOC')
 Dir.chdir('/usr/src/puppetlabs-training-bootstrap') do
  cputs "Running r10k Puppetfile install"
  system('PATH=$PATH:/opt/puppetlabs/puppet/bin:/usr/local/bin r10k puppetfile install')
 end
 cputs "Running puppet apply on site.pp"
 system('PATH=$PATH:/opt/puppetlabs/puppet/bin puppet apply --modulepath=/usr/src/puppetlabs-training-bootstrap/modules --verbose /usr/src/puppetlabs-training-bootstrap/manifests/site.pp')
end

desc "Post build cleanup tasks"
task :post do
  version = YAML.load(File.read('version.yaml'))
  # Put version file in place on VM
  cputs "Editing /etc/vm-version"
  FileUtils.copy('version.yaml','/etc/vm-version')
  cputs "Editing /etc/puppetlabs-release"
  File.open('/etc/puppetlabs-release', 'w') do |file|
    file.write "#{version[:major]}.#{version[:minor]}"
  end
  # Run cleanup manifest
  cputs "Running cleanup manifest"
  system('PATH=$PATH:/opt/puppetlabs/bin puppet apply --modulepath=/usr/src/puppetlabs-training-bootstrap/modules --verbose /usr/src/puppetlabs-training-bootstrap/manifests/post.pp')

  # Uninstall the agent for student and training VMs
  if ['student','training'].include? VMTYPE then
    %x{puppet resource yumrepo puppetlabs-pc1 enabled=0}
    %x{yum -y remove puppet-agent}
  end

end

desc "Full Training VM Build"
task :training do
  cputs "Building Training VM"
  Rake::Task["standalone_puppet"].execute
  Rake::Task["training_pre"].execute
  Rake::Task["build"].execute
  Rake::Task["post"].execute
end

desc "Full Learning VM Build"
task :learning do
  cputs "Building Learning VM"
  Rake::Task["standalone_puppet"].execute
  Rake::Task["learning_pre"].execute
  Rake::Task["build"].execute
  Rake::Task["post"].execute
end

desc "Full Student VM Build"
task :student do
  cputs "Building Student VM"
  Rake::Task["standalone_puppet"].execute
  Rake::Task["student_pre"].execute
  Rake::Task["build"].execute
  Rake::Task["post"].execute
end

desc "Full Puppetfactory VM Build"
task :master do
  cputs "Building Master VM"
  Rake::Task["install_pe"].execute
  Rake::Task["master_pre"].execute
  Rake::Task["build"].execute
  Rake::Task["post"].execute
end

desc "Full LMS VM Build"
task :lms do
  cputs "Building LMS VM"
  Rake::Task["standalone_puppet"].execute
  Rake::Task["lms_pre"].execute
  Rake::Task["build"].execute
  Rake::Task["post"].execute
end

## The job that calls this needs to be tied to a builder with ovftool and the int-resources NFS export mounted.
## Currently just pe-vm-builder-1
desc "Package and ship a VM"
task :ship do
  vmname = ENV['VMNAME'].split(".").first || fail("VMNAME not set, usually set via a properties file from the build job")
  cputs "Exporting #{vmname} from vSphere"
  ovapath = retrieve_vm_as_ova(vmname)
  ovaname = File.basename(ovapath)
  cputs "Exporting #{ovaname} to vSphere as \"#{VMTYPE}\""
  ship_vm_to_vmware(ovapath)
  cputs "Copying #{ovaname} to int-resources"
  ship_vm_to_dir(ovapath, "/mnt/nfs/EducationVMS/#{VMTYPE}")
  cputs "#{ovaname} is now available at http://int-resources.ops.puppetlabs.net/EducationVMS/#{VMTYPE}/#{ovaname}"
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

def gitclone(source,destination,branch,tag = nil)
  if File.directory?(destination) then
    system("cd #{destination} && (git pull origin #{branch}") or raise(Error, "Cannot pull ${source}")
  else
    system("git clone #{source} #{destination} -b #{branch}") or raise(Error, "Cannot clone #{source}")
    system("cd #{destination} && git checkout #{tag}") if tag
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

def retrieve_vm_as_ova(vmname)
  ovaname = "puppet-#{PEVERSION}-#{VMTYPE}vm-#{PTBVERSION[:major]}.#{PTBVERSION[:minor]}"
  vcenter_config = File.join(CACHEDIR, ".vmwarecfg.yml") || ENV["VCENTER_CONFIG"]
  vcenter_settings = YAML::load(File.open(vcenter_config))
  FileUtils.rm_rf(OVFDIR) if File.directory?(OVFDIR)
  FileUtils.mkdir_p(OVFDIR)
  Dir.chdir(BUILDDIR) do
    verbose(false) do
      sh(%Q</usr/bin/ovftool --noSSLVerify --targetType=OVA --compress=9 --name=#{ovaname} --powerOffSource vi://#{vcenter_settings['username']}\\@puppetlabs.com:#{vcenter_settings['password']}@vmware-vc2.ops.puppetlabs.net/opdx2/vm/vmpooler/centos-6-i386/#{vmname}  #{OVFDIR}/>)
    end
  end
  File.join(OVFDIR, ovaname) + ".ova"
end

def ship_vm_to_vmware(vmpath)
  require 'rbvmomi'
  vcenter_config = File.join(CACHEDIR, ".vmwarecfg.yml") || ENV["VCENTER_CONFIG"]
  vcenter_settings = YAML::load(File.open(vcenter_config))
  Dir.chdir(BUILDDIR) do
    verbose(false) do
      sh(%Q</usr/bin/ovftool --noSSLVerify --network='delivery' --datastore='instance1' -o --powerOffTarget -n=#{VMTYPE} #{vmpath} vi://#{vcenter_settings['username']}\@puppetlabs.com:#{vcenter_settings['password']}@vmware-vc2.ops.puppetlabs.net/opdx2/host/mac1>)
    end
  end
  vim = RbVmomi::VIM.connect(
    :host => 'vmware-vc2.ops.puppetlabs.net', 
    :user => "#{vcenter_settings['username']}\@puppetlabs.com", 
    :password => "#{vcenter_settings['password']}", 
    :insecure => 'true')
  rootFolder = vim.serviceInstance.content.rootFolder
  dc = rootFolder.childEntity.grep(RbVmomi::VIM::Datacenter).find { |x| x.name == "opdx2" } or fail "datacenter not found"
  vm = dc.find_vm(VMTYPE) or fail "VM not found"
  cputs "Powering on VM"
  vm.PowerOnVM_Task.wait_for_completion
  vm_ip = nil
  5.times do
    vm_ip = vm.guest_ip
    cputs "#{VMTYPE} IP is #{vm_ip}"
    break unless vm_ip == nil
    sleep 60
  end
  fail "Did not receive an IP address" if vm_ip == nil
end

def ship_vm_to_dir(vmpath, destination)
  FileUtils.cp(vmpath, destination)
  FileUtils.chmod(0644, File.join(destination, File.basename(vmpath)))
end

# vim: set sw=2 sts=2 et tw=80 :
