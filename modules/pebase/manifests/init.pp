class pebase {
  exec { 'Curl PE tarball':
    command => '/usr/bin/curl -s -o /root/puppet-enterprise-1.1-centos-5-x86_64.tar http://pm.puppetlabs.com/puppet-enterprise/1.1/puppet-enterprise-1.1-centos-5-x86_64.tar',
    creates => '/root/puppet-enterprise-1.1-centos-5-x86_64.tar',
  }
  # do some basic setup for PE
  file { ['/etc/puppetlabs/',
          '/etc/puppetlabs/puppet/',
          '/etc/puppetlabs/puppet/modules',
          '/etc/puppetlabs/puppet/manifests',
         ]:
    ensure => directory
  }
  file { '/root/dev-answers.txt':
    source => 'puppet:///modules/pebase/dev-answers.txt',
  }
  file { '/root/pe-agent.answers':
    source => 'puppet:///modules/pebase/pe-agent.answers',
  }
  file { '/root/pe-puppetmaster.answers':
    source => 'puppet:///modules/pebase/pe-puppetmaster.answers',
  }
}
