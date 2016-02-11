# Install docker module
sudo puppet module install garethr-docker --modulepath=/etc/puppetlabs/code/modules

# Run puppet once
sudo puppet agent -t


# Stop all PE processes to free up memory
for s in `find /etc/init.d/ -name pe* -type f -printf "%f\n"`
do
  sudo service $s stop
done

# Clean up PE installer files
sudo rm -rf /root/puppet-enterprise*
sudo rm -rf /root/puppet-enterprise
sudo rm -rf /usr/src/installer


# Clean up other random files
sudo rm -rf /usr/src/puppetlabs-training-bootstrap
sudo rm -rf /usr/src/puppet
sudo rm -rf /usr/src/kernels
sudo rm -rf /var/cache/yum
sudo rm -rf /opt/puppet/share/ri
sudo rm -rf /home/vagrant/linux.iso

sudo yum clean all
