export PATH=$PATH:/opt/puppetlabs/bin/

# Make sure it's ok to run puppet
while [ -f /opt/puppetlabs/puppet/cache/state/agent_catalog_run.lock ]; do echo Waiting for Puppet Run to complete; sleep 10; done
while ! curl -k -I https://localhost:8140/packages/ 2>/dev/null | grep "200 OK" > /dev/null; do echo Waiting for Puppet Server to start; sleep 10; done
echo Initializing Puppet Server
sleep 60

# Run puppet twice
puppet agent -t

echo Puppet run completed

# Stop all PE processes to free up memory
for s in `find /etc/init.d/ -name pe* -type f -printf "%f\n"`
do
  service $s stop
done

# Clean up PE installer files
rm -rf /root/puppet-enterprise*
rm -rf /root/puppet-enterprise
rm -rf /usr/src/installer


# Clean up other random files
rm -rf /usr/src/education-builds
rm -rf /usr/src/puppet
rm -rf /usr/src/kernels
rm -rf /var/cache/yum
rm -rf /opt/puppet/share/ri
rm -rf /home/vagrant/linux.iso
rm -rf /training

yum clean all
