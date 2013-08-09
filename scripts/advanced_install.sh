#!/bin/bash

export MASTER_HOSTNAME='advanced.puppetlabs.vm'
export CLASSROOM_HOSTNAME='classroom.puppetlabs.vm'

# Setup the hostname for the system
export RUBYLIB=/usr/src/puppet/lib:/usr/src/facter/lib
/usr/src/puppet/bin/puppet resource host "$MASTER_HOSTNAME" \
  ensure=present \
  host_aliases="${MASTER_HOSTNAME/.*/}" \
  ip=`/usr/src/facter/bin/facter ipaddress`

/bin/sed -i "s/HOSTNAME.*/HOSTNAME=$MASTER_HOSTNAME/" /etc/sysconfig/network
/bin/hostname "$MASTER_HOSTNAME"

# Setup master hostname
# Might switch to this https://github.com/adrienthebo/vagrant-hosts
/usr/src/puppet/bin/puppet resource host $CLASSROOM_HOSTNAME \
      ensure=present \
      host_aliases="${CLASSROOM_HOSTNAME/.*/},puppet" \
      ip='10.0.0.201'

unset RUBYLIB

q_all_in_one_install=n
q_database_install=n
q_install=y
q_pe_database=n
q_puppet_cloud_install=n
q_puppet_enterpriseconsole_install=n
q_puppet_symlinks_install=y
q_puppetagent_certname="$MASTER_HOSTNAME"
q_puppetagent_install=y
q_puppetagent_server="$MASTER_HOSTNAME"
q_puppetdb_hostname="$CLASSROOM_HOSTNAME"
q_puppetdb_install=n
q_puppetdb_port=8081
q_puppetmaster_certname="$MASTER_HOSTNAME"
q_puppetmaster_dnsaltnames="${MASTER_HOSTNAME/.*/},$MASTER_HOSTNAME,puppet,puppet.puppetlabs.vm"
q_puppetmaster_enterpriseconsole_hostname="$CLASSROOM_HOSTNAME"
q_puppetmaster_enterpriseconsole_port=443
q_puppetmaster_install=y
q_run_updtvpkg=n
q_vendor_packages_install=y

# Run the master installation with an empty file given the exports above
exec /root/puppet-enterprise/puppet-enterprise-installer -a /etc/motd
