# -*- mode: ruby -*-
# vi: set ft=ruby :

$user = ENV['USER']

Vagrant.configure("2") do |config|


  # Fundamentals
  config.vm.define :master do |master_config|
    master_config.vm.box = "master"
    master_config.vm.box_url = "file:///Users/#{$user}/Sites/build/vagrant/centos-latest.box"
    master_config.vm.network :private_network, ip: "10.0.0.101"
    master_config.vm.synced_folder ".", "/vagrant", id: "vagrant-root", disabled: true
    master_config.vm.provision :shell,
      :path => "scripts/master_install.sh"
  end

  config.vm.define :fundamentals do |fundamentals_config|
    fundamentals_config.vm.box = "fundamentals"
    fundamentals_config.vm.box_url = "file:///Users/#{$user}/Sites/build/vagrant/centos-latest.box"
    fundamentals_config.vm.network :private_network, ip: "10.0.0.102"
    fundamentals_config.vm.synced_folder ".", "/vagrant", id: "vagrant-root", disabled: true
    fundamentals_config.vm.provision :shell,
            :path => "scripts/fundamentals_install.sh"
  end

  # Advanced
  config.vm.define :classroom do |classroom_config|
    classroom_config.vm.box = "classroom"
    classroom_config.vm.box_url = "file:///Users/#{$user}/Sites/build/vagrant/centos-latest.box"
    classroom_config.vm.network :private_network, ip: "10.0.0.201"
    classroom_config.vm.synced_folder ".", "/vagrant", id: "vagrant-root", disabled: true
    classroom_config.vm.provision :shell,
      :path => "scripts/classroom_install.sh"
  end

  config.vm.define :advanced do |advanced_config|
    advanced_config.vm.box = "advanced"
    advanced_config.vm.box_url = "file:///Users/#{$user}/Sites/build/vagrant/centos-latest.box"
    advanced_config.vm.network :private_network, ip: "10.0.0.202"
    advanced_config.vm.synced_folder ".", "/vagrant", id: "vagrant-root", disabled: true
    advanced_config.vm.provision :shell,
            :path => "scripts/advanced_install.sh"
  end
end
