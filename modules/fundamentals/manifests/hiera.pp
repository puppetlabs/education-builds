# Make sure that Hiera is configured for all nodes so that we
# can work through the hiera sections without teaching them
# how to configure it.
class fundamentals::hiera {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { '/etc/puppetlabs/puppet/hieradata':
    ensure => directory,
  }

  file { '/etc/puppetlabs/puppet/hiera.yaml':
    ensure  => file,
    source  => 'puppet:///modules/fundamentals/hiera.yaml',
    replace => false,
  }

  file { '/etc/puppetlabs/puppet/hieradata/defaults.yaml':
    ensure  => file,
    source  => 'puppet:///modules/fundamentals/defaults.yaml',
    replace => false,
  }
}
