# == Class: edu_env
#
# Full description of class edu_env here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { edu_env:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2011 Your name here, unless otherwise noted.
#
class edu_env {

  concat{ 'puppet_conf_concat':
    name  => '/etc/puppetlabs/puppet/puppet.conf',
    owner => 'pe-puppet',
    group => 'pe-puppet',
    mode  => '0644',
  }

  concat::fragment{ 'puppet_conf':
    target  => '/etc/puppetlabs/puppet/puppet.conf',
    source  => '/root/puppet.conf',
    order   => 01,
  }

  exec { 'cp_puppet_conf':
    command => '/bin/cp /etc/puppetlabs/puppet/puppet.conf /root/puppet.conf',
    unless  => '/usr/bin/test -f /root/puppet.conf',
    before  => Concat::Fragment['puppet_conf'],
  }

}
