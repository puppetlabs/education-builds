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
    echo Building $1 VM
		yum install -y git yum-utils ruby-devel ruby rubygems gcc ntpdate
    yum clean all
		gem install rake --no-rdoc --no-ri -v 10.5.0
		gem install json --no-rdoc --no-ri

		cd /usr/src/
    ln -s /vagrant /usr/src/education-builds
		cd /usr/src/education-builds/scripts

		rake $1_full
SCRIPT

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
	
		master_config.vm.provision "shell" do |s|
      s.inline = $script
      s.args   = "'master'"
    end
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
	
		training_config.vm.provision "shell" do |s|
      s.inline = $script
      s.args   = "'training'"
    end
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

		student_config.vm.provision "shell" do |s|
      s.inline = $script
      s.args   = "'student'"
    end
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
		
		learning_config.vm.provision "shell" do |s|
      s.inline = $script
      s.args   = "'learning'"
    end
	end
end
