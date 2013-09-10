#!/bin/bash

export AGENT_HOSTNAME='fundamentals.puppetlabs.vm'
export MASTER_HOSTNAME='master.puppetlabs.vm'

# Setup the hostname for the system
export RUBYLIB=/usr/src/puppet/lib:/usr/src/facter/lib
/usr/src/puppet/bin/puppet resource host "$AGENT_HOSTNAME" \
  ensure=present \
  host_aliases="${AGENT_HOSTNAME/.*/}" \
  ip=`/usr/src/facter/bin/facter ipaddress`

/bin/sed -i "s/HOSTNAME.*/HOSTNAME=$AGENT_HOSTNAME/" /etc/sysconfig/network
/bin/hostname "$AGENT_HOSTNAME"

# Setup master hostname
# Might switch to this https://github.com/adrienthebo/vagrant-hosts
/usr/src/puppet/bin/puppet resource host $MASTER_HOSTNAME \
    ensure=present \
    host_aliases="${MASTER_HOSTNAME/.*/} puppet" \
    ip='10.0.0.101'

unset RUBYLIB
export q_all_in_one_install=n
export q_database_install=n
export q_fail_on_unsuccessful_master_lookup=y
export q_install=y
export q_pe_database=n
export q_puppet_cloud_install=n
export q_puppet_enterpriseconsole_install=n
export q_puppet_symlinks_install=y
export q_puppetagent_certname="$AGENT_HOSTNAME"
export q_puppetagent_install=y
export q_puppetagent_server="$MASTER_HOSTNAME"
export q_puppetca_install=n
export q_puppetdb_install=n
export q_puppetmaster_install=n
export q_run_updtvpkg=n
export q_vendor_packages_install=y

# Run the master installation with an empty file given the exports above
exec /root/puppet-enterprise/puppet-enterprise-installer -a /etc/motd
