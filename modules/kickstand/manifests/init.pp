class kickstand {
  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['kickstand'],
  }

  package { 'sinatra':
    ensure   => present,
    provider => gem,
  }

  # manage this file so kickstand doesn't break the master with ownership issues
  file { '/etc/puppetlabs/puppet/autosign.conf':
    ensure => file,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0644',
  }

  $directories = [
    '/opt/kickstand',
    '/opt/kickstand/bin',
    '/opt/kickstand/share',
    '/opt/kickstand/share/public',
    '/opt/kickstand/share/views',
  ]

  file { $directories:
    ensure  => directory,
  }

  file { '/opt/kickstand/share/public/yum':
    ensure  => link,
    target  => '/var/yum/mirror',
  }

  file { '/opt/kickstand/bin/kickstand':
    ensure => file,
    mode   => '0744',
    replace => false,
    source => 'puppet:///modules/kickstand/bin/kickstand',
  }

  file { '/opt/kickstand/share/views/kickstart.erb':
    ensure => file,
    replace => false,
    source => 'puppet:///modules/kickstand/views/kickstart.erb',
  }

  file { '/opt/kickstand/share/views/mirror.erb':
    ensure => file,
    source => 'puppet:///modules/kickstand/views/mirror.erb',
  }

  file { '/etc/init.d/kickstand':
    ensure => file,
    mode   => '0744',
    source => 'puppet:///modules/kickstand/bin/kickstand.init',
  }

  service { 'kickstand':
    ensure  => running,
    enable  => true,
    require => File['/etc/init.d/kickstand'],
  }

}
