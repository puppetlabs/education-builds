class fundamentals::console::patch {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }
  Exec {
    cwd         => '/opt/puppet/share/live-management',
    path        => '/usr/bin',
    creates     => '/tmp/patches/lock',
    before      => File['/tmp/patches/lock'],
    refreshonly => true,
  }

  # each patch to be applied should drop a file in /tmp/patches
  file { '/tmp/patches/selectNone.diff':
    ensure => file,
    source => 'puppet:///modules/fundamentals/selectNone.diff',
  }
  # then apply it
  exec { 'Live Management select none':
    command   => 'patch -p0 < /tmp/patches/selectNone.diff',
    subscribe => File['/tmp/patches/selectNone.diff'],
  }

  # completion flag
  file { '/tmp/patches/lock':
    ensure => file,
  }
  file { '/tmp/patches':
    ensure => directory,
  }
}
