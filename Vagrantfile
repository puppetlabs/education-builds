# -*- mode: ruby -*-
# vi: set ft=ruby :


# Vagrant File for all Education VMs
# 
#
#
GIT_ACCOUNT = %x(git remote config --get remote.origin.url | sed -n -e 's/^.*github.com.\([a-z]*\).*$/\1/p')
GIT_BRANCH = %x(git rev-parse --abbrev-ref HEAD)
VAGRANTFILE_API_VERSION = "2"
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
$script = <<SCRIPT
		yum install -y git yum-utils ruby-devel ruby rubygems gcc ntpdate
    yum clean all
		gem install rake --no-rdoc --no-ri -v 10.5.0
		gem install json --no-rdoc --no-ri

		cd /usr/src/
		git clone https://github.com/GIT_ACCOUNT/puppetlabs-training-bootstrap -b GIT_BRANCH
		cd /usr/src/puppetlabs-training-bootstrap/scripts

		rake VMTYPE_full
SCRIPT
$script.sub! 'GIT_ACCOUNT', GIT_ACCOUNT
$script.sub! 'GIT_BRANCH', GIT_BRANCH

	config.vm.define :master, autostart: false do |master_config|
		master_config.vm.box = "puppetlabs/centos-7.2-64-nocm"
		master_config.vm.network "public_network"

		master_config.vm.provider "virtualbox" do |v|
      v.memory = 6144
			v.cpus = 2
			v.customize ["modifyvm", :id, "--ioapic", "on"]
		end
		
		master_config.vm.provider "vmware_fusion" do |v|
			v.vmx["memsize"] = "6144"
  		v.vmx["numvcpus"] = "2"
		end
	
		$script.sub! 'VMTYPE', 'master'
		master_config.vm.provision "shell", inline: $script
	end

	config.vm.define :training, autostart: false do |training_config|
		training_config.vm.box = "puppetlabs/centos-7.2-64-nocm"
		training_config.vm.network "public_network"

		training_config.vm.provider "virtualbox" do |v|
			v.memory = 4096
			v.cpus = 2
			v.customize ["modifyvm", :id, "--ioapic", "on"]
		end
		
		training_config.vm.provider "vmware_fusion" do |v|
			v.vmx["memsize"] = "4096"
  		v.vmx["numvcpus"] = "2"
		end
	
		$script.sub! 'VMTYPE', 'training'
		training_config.vm.provision "shell", inline: $script
	end

	config.vm.define :student do |student_config|
		student_config.vm.box = "puppetlabs/centos-6.6-32-nocm"
		student_config.vm.network "public_network"

		student_config.vm.provider "virtualbox" do |v|
			v.memory = 1024
			v.cpus = 2
			v.customize ["modifyvm", :id, "--ioapic", "on"]
		end
		
		student_config.vm.provider "vmware_fusion" do |v|
			v.vmx["memsize"] = "1024"
  		v.vmx["numvcpus"] = "2"
		end

		$script.sub! 'VMTYPE', 'student'

		student_config.vm.provision "shell", inline: $script
	end


	config.vm.define :learning, autostart: false do |learning_config|
		learning_config.vm.box = "puppetlabs/centos-7.2-64-nocm"

		#Uncomment this line to use bridged networking
		#learning_config.vm.network "public_network"
		learning_config.vm.network "forwarded_port", guest: 443, host: 8443
		learning_config.vm.network "forwarded_port", guest: 80, host: 8080

		learning_config.vm.provider "virtualbox" do |v|
			v.memory = 1024
			v.cpus = 2
			v.customize ["modifyvm", :id, "--ioapic", "on"]
		end

		learning_config.vm.provider "vmware_fusion" do |v|
			v.vmx["memsize"] = "1024"
  		v.vmx["numvcpus"] = "2"
		end
		
		$script.sub! 'VMTYPE', 'learning'

		learning_config.vm.provision "shell", inline: $script 
	end
end
