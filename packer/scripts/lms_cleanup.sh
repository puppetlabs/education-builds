#LMS VM cleanup scripts

# Get puppet config ready
PATH=/opt/puppet/bin:$PATH
puppet config set certname ${HOSTNAME}
puppet config set server ${HOSTNAME}

# Stop all PE processes to free up memory
for s in `find /etc/init.d/ -name pe* -type f -printf "%f\n"`
do
  service $s stop
done

# Clean up PE installer files
rm -rf /usr/src/puppet-enterprise*
rm -rf /etc/yum.repos.d/puppet_enterprise.repo
rm -rf /usr/src/puppet-enterprise
rm -rf /usr/src/installer

# Remove packages PE will regenerate agent installer
rm -rf /opt/puppet/packages

# Clean up other random files
rm -rf /usr/src/puppetlabs-training-bootstrap
rm -rf /usr/src/puppet
rm -rf /usr/share/doc/*
rm -rf /usr/src/kernels

yum clean all
