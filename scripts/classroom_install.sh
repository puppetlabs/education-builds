#!/bin/bash

export MASTER_HOSTNAME='classroom.puppetlabs.vm'

# Setup the hostname for the system
export RUBYLIB=/usr/src/puppet/lib:/usr/src/facter/lib
/usr/src/puppet/bin/puppet resource host "$MASTER_HOSTNAME" \
  ensure=present \
  host_aliases="${MASTER_HOSTNAME/.*/}" \
  ip=`/usr/src/facter/bin/facter ipaddress`
unset RUBYLIB

/bin/sed -i "s/HOSTNAME.*/HOSTNAME=$MASTER_HOSTNAME/" /etc/sysconfig/network
/bin/hostname "$MASTER_HOSTNAME"

export q_all_in_one_install=y
export q_database_host=localhost
export q_database_install=y
export q_database_port=5432
export q_database_root_password=T3fXWQlfNDPiZA0zewA8
export q_database_root_user=pe-postgres
export q_install=y
export q_pe_database=y
export q_puppet_cloud_install=n
export q_puppet_enterpriseconsole_auth_database_name=console_auth
export q_puppet_enterpriseconsole_auth_database_password=AXWnz9TL0UPVB2PyOLRv
export q_puppet_enterpriseconsole_auth_database_user=console_auth
export q_puppet_enterpriseconsole_auth_password=puppetlabs
export q_puppet_enterpriseconsole_auth_user_email=admin@puppetlabs.com
export q_puppet_enterpriseconsole_database_name=console
export q_puppet_enterpriseconsole_database_password=6A98ZMWaooJa78Eo6q5T
export q_puppet_enterpriseconsole_database_user=console
export q_puppet_enterpriseconsole_httpd_port=443
export q_puppet_enterpriseconsole_install=y
export q_puppet_enterpriseconsole_master_hostname="$MASTER_HOSTNAME"
export q_puppet_enterpriseconsole_smtp_host=localhost
export q_puppet_enterpriseconsole_smtp_password=
export q_puppet_enterpriseconsole_smtp_port=25
export q_puppet_enterpriseconsole_smtp_use_tls=n
export q_puppet_enterpriseconsole_smtp_user_auth=n
export q_puppet_enterpriseconsole_smtp_username=
export q_puppet_symlinks_install=y
export q_puppetagent_certname="$MASTER_HOSTNAME"
export q_puppetagent_install=y
export q_puppetagent_server="$MASTER_HOSTNAME"
export q_puppetdb_database_name=pe-puppetdb
export q_puppetdb_database_password=3i1YuvUqaY48ruwKmeVz
export q_puppetdb_database_user=pe-puppetdb
export q_puppetdb_hostname=$MASTER_HOSTNAME
export q_puppetdb_install=y
export q_puppetdb_port=8081
export q_puppetmaster_certname="$MASTER_HOSTNAME"
export q_puppetmaster_dnsaltnames="${MASTER_HOSTNAME/.*/},${MASTER_HOSTNAME},puppet,puppet.puppetlabs.vm"
export q_puppetmaster_enterpriseconsole_hostname=localhost
export q_puppetmaster_enterpriseconsole_port=443
export q_puppetmaster_install=y
export q_run_updtvpkg=n
export q_vendor_packages_install=y

# Run the master installation with an empty file given the exports above
exec /root/puppet-enterprise/puppet-enterprise-installer -a /etc/motd
