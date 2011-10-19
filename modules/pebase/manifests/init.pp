class pebase {
  ## Replaced with a file resource below
  #exec { 'Curl PE tarball':
  #  command => '/usr/bin/curl -so /root/puppet-enterprise-1.2.3-el-5-i386.tar.gz http://pm.puppetlabs.com/puppet-enterprise/1.2.3/puppet-enterprise-1.2.3-el-5-i386.tar.gz',
  #  creates => '/root/puppet-enterprise-1.2.3-el-5-i386.tar.gz',
  #}

  # do some basic setup for PE
  file { ['/etc/puppetlabs/',
          '/etc/puppetlabs/puppet/',
          '/etc/puppetlabs/puppet/modules',
          '/etc/puppetlabs/puppet/manifests',
         ]:
    ensure => directory
  }
  #file { '/root/puppet-enterprise-1.2.3-el-5-i386.tar.gz':
  #  source => 'puppet:///modules/pebase/puppet-enterprise-1.2.3-el-5-i386.tar.gz',
  #}
  file { '/root/dev-answers.txt':
    source => 'puppet:///modules/pebase/dev-answers.txt',
  }
  file { '/root/pe-agent.answers':
    source => 'puppet:///modules/pebase/pe-agent.answers',
  }
  file { '/root/pe-puppetmaster.answers':
    source => 'puppet:///modules/pebase/pe-puppetmaster.answers',
  }
  file { '/root/puppet-enterprise':
    ensure => symlink,
    target => '/root/puppet-enterprise-1.2.3-el-5-i386',
  }
}
