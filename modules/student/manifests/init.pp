class student {
  # ILT training-specific setup

  # Populate the VM with our helper scripts.
  file {'/usr/local/bin':
    ensure  => directory,
    recurse => true,
    replace => false,
    source  => '/usr/src/puppetlabs-training-bootstrap/scripts/classroom',
  }

  file { '/usr/src/wordpress':
    ensure => directory,
  }

  exec { 'Cache WordPress':
    cwd       => '/usr/src/wordpress',
    command   => '/usr/bin/wget --no-clobber --no-check-certificate https://www.wordpress.org/wordpress-3.8.tar.gz',
    creates   => '/usr/src/wordpress/wordpress-3.8.tar.gz',
    logoutput => 'on_failure',
    user      => 'root',
    group     => 'root',
    require   => File['/usr/src/wordpress'],
  }
}
