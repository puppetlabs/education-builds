class pebase {
  ## Replaced with a file resource below
  #exec { 'Curl PE tarball':
  #  command => '/usr/bin/curl -so /root/puppet-enterprise-2.0.0-el-5-i386.tar.gz http://pm.puppetlabs.com/puppet-enterprise/2.0.0/puppet-enterprise-2.0.0-el-5-i386.tar.gz',
  #  creates => '/root/puppet-enterprise-2.0.0-el-5-i386.tar.gz',
  #}

  # do some basic setup for PE
  file { ['/etc/puppetlabs/',
          '/etc/puppetlabs/puppet/',
          '/etc/puppetlabs/puppet/modules',
          '/etc/puppetlabs/puppet/manifests',
         ]:
    ensure => directory
  }
  file { '/root/puppet-enterprise':
    ensure => symlink,
    target => '/root/puppet-enterprise-2.0.0-el-5-i386',
  }
}
