class kickstand {
  File {
    owner => 'root',
    group => 'root',
  }

  file { '/opt/kickstand':
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/kickstand/kickstand',
  }

  file { '/opt/kickstand/share/public/yum':
    ensure  => link,
    target  => '/var/yum/mirror',
    require => File['/opt/kickstand'],
  }

  file { ['/opt/kickstand/bin/kickstand', '/opt/kickstand/bin/kickstand.init']:
    ensure => file,
    mode   => '0744',
  }

  file { '/etc/init.d/kickstand':
    ensure  => link,
    target  => '/opt/kickstand/bin/kickstand.init',
    require => File['/opt/kickstand/bin/kickstand.init'],
  }

  service { 'kickstand':
    ensure  => running,
    enable  => true,
    require => File['/etc/init.d/kickstand'],
  }

}
