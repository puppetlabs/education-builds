class pebase {
  #exec { 'Curl PE tarball':
  #  command => 'curl -s -o /root/puppet-enterprise-1.1-centos-5-x86_64.tar http://kshost/',
  #  source => '',
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
