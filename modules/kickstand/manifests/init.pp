class kickstand {
  File {
    owner => 'root',
    group => 'root',
  }

  # manage this file so kickstand doesn't break the master with ownership issues
  file { '/etc/puppetlabs/puppet/autosign.conf':
    ensure => file,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0644',
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

  file { '/opt/kickstand/bin/kickstand':
    ensure => file,
    mode   => '0744',
    source => 'puppet:///modules/kickstand/kickstand/bin/kickstand',
  }

  file { '/opt/kickstand/bin/kickstand.init':
    ensure => file,
    mode   => '0744',
    source => 'puppet:///modules/kickstand/kickstand/bin/kickstand.init',
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
