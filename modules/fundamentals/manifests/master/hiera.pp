# You can use this if you're lazy and/or don't remember
# the hiera.yaml format. It's preferred to type it out.
# Drives the point home how easy it is to configure.
class fundamentals::master::hiera {
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

  file { '/etc/puppetlabs/puppet/hieradata/common.yaml':
    ensure  => file,
    content => template('fundamentals/common.yaml.erb'),
    replace => false,
  }
}
