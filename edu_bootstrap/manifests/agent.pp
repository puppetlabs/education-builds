class edu_bootstrap::agent {

  require edu_bootstrap::repo

  package { 'fuse-sshfs':
    ensure => installed,
  }

  file { '/root/master_home':
    ensure => directory,
  }

  file { '/etc/puppetlabs/puppet/modules':
    ensure => 'symlink',
    target => '/root/master_home/modules',
  }

# concat::fragment{ "apply_modulepath":
#   target  => '/etc/puppetlabs/puppet/puppet.conf',
#   content => "[user]\n  modulepath=/root/master_home/modules\n",
#   order   => '02',
#   require => Concat::Fragment['puppet_conf'],
# }

}
