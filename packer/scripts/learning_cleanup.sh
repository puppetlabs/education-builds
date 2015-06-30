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
rm -rf /usr/src/puppetlabs-training-bootstrap
rm -rf /usr/src/puppet
rm -rf /usr/share/doc/*
rm -rf /usr/src/kernels

# Exec bash to enable bash history
exec bash
