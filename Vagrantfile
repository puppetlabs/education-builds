# -*- mode: ruby -*-
# vi: set ft=ruby :


# Vagrant File for all Education VMs
# 
#
#

VAGRANTFILE_API_VERSION = "2"
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
$script = <<SCRIPT
		yum install -y git yum-utils ruby-devel ruby rubygems
		gem install rake json

		cd /usr/src/
		git clone https://github.com/puppetlabs/puppetlabs-training-bootstrap
		cd /usr/src/puppetlabs-training-bootstrap/

		rake VMTYPE
SCRIPT

	config.vm.define :training, autostart: false do |training_config|
		training_config.vm.box = "puppetlabs/centos-6.6-32-nocm"
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
		student_config.vm.box = "puppetlabs/centos-6.5-32-nocm"
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
		learning_config.vm.box = "puppetlabs/centos-6.5-32-nocm"

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
