class training {
  # ILT training-specific setup

  # Set up the /root/bin directory.
  file {'/root/bin':
    ensure => link,
    target => '/usr/src/puppetlabs-training-bootstrap/scripts/classroom',
  }

  file { '/usr/src/wordpress':
    ensure => directory,
  }

  host { 'training.puppetlabs.vm':
    ensure       => 'present',
    host_aliases => ['training', 'localhost', 'localhost.localdomain'],
    ip           => '127.0.0.1',
    target       => '/etc/hosts',
  }

  host { 'localhost':
    ensure       => 'present',
    host_aliases => ['localhost.localdomain', 'localhost6', 'localhost6.localdomain6'],
    ip           => '::1',
    target       => '/etc/hosts',
  }

  exec { 'Cache WordPress':
    cwd       => '/usr/src/wordpress',
    command   => '/usr/bin/wget --no-clobber https://www.wordpress.org/wordpress-3.8.tar.gz',
    creates   => '/usr/src/wordpress/wordpress-3.8.tar.gz',
    logoutput => 'on_failure',
    user      => 'root',
    group     => 'root',
    require   => File['/usr/src/wordpress'],
  }
}
