# Author: Cody Herriges

class puppetbase {
  # do some basic setup for PE
  file { ['/etc/puppetlabs/',
          '/etc/puppetlabs/puppet/',
          '/etc/puppetlabs/puppet/modules',
          '/etc/puppetlabs/puppet/manifests',
         ]:
    ensure => directory
  }
  file { '/etc/puppetlabs/puppet/manifests/site.pp':
    content => ''
  }
  # TODO - install our git version of Puppet using vcsrepo
}
