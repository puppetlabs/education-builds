# Make sure that Hiera is configured for agent nodes so that we
# can work through the hiera sections without teaching them
# how to configure it.
class classroom::agent::hiera (
  $managerepos = $classroom::managerepos,
) inherits classroom {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  if $managerepos {
    file { '/etc/puppetlabs/puppet/hieradata':
      ensure => link,
      target => '/root/puppetcode/hieradata',
    }

    file { '/etc/puppetlabs/puppet/hiera.yaml':
      ensure => link,
      target => '/root/puppetcode/hiera.yaml',
      force  => true,
    }

    file { '/root/puppetcode/hiera.yaml':
      ensure => file,
      source => 'puppet:///modules/classroom/hiera.agent.yaml',
      replace => false,
    }

  }
  else {
    file { '/etc/puppetlabs/puppet/hieradata':
      ensure => directory,
    }

    # Because PE writes a default, we cannot use replace => false
    file { '/etc/puppetlabs/puppet/hiera.yaml':
      ensure => file,
      source => 'puppet:///modules/classroom/hiera.agent.yaml',
    }
  }

  file { '/etc/puppetlabs/puppet/hieradata/defaults.yaml':
    ensure  => file,
    source  => 'puppet:///modules/classroom/defaults.yaml',
    replace => false,
  }
}
