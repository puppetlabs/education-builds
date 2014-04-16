class training {
  # ILT training-specific setup

  file { '/usr/src/wordpress':
    ensure => directory,
  }
  exec { 'Cache WordPress':
    cwd       => '/usr/src/wordpress',
    command   => '/usr/bin/wget --no-clobber http://wordpress.org/wordpress-3.8.tar.gz',
    creates   => '/usr/src/wordpress/wordpress-3.8.tar.gz',
    logoutput => 'on_failure',
    user      => 'root',
    group     => 'root',
    require   => File['/usr/src/wordpress'],
  }
}
