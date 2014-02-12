class fundamentals::console::patch {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }
  Exec {
    cwd     => '/opt/puppet/share/live-management',
    path    => '/usr/bin',
    creates => '/tmp/patches/lock',
    before  => File['/tmp/patches/lock'],
  }

  file { '/tmp/patches':
    ensure => directory,
  }

  file { '/tmp/patches/selectNone.diff':
    ensure => file,
    source => 'puppet:///modules/fundamentals/selectNone.diff',
  }

  exec { 'Live Management select none':
    command => 'patch -p0 < /tmp/patches/selectNone.diff',
    require => File['/tmp/patches/selectNone.diff'],
  }

  # completion flag
  file { '/tmp/patches/lock':
    ensure => file,
  }
}