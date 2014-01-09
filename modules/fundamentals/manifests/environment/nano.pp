class fundamentals::environment::nano {
  package { 'nano':
    ensure => present,
  }

  file { '/root/.nanorc':
    ensure  => 'file',
    source  => 'puppet:///modules/fundamentals/environment/nano/nanorc',
  }

  file { '/root/.nano.d':
    ensure => directory,
  }

  file { '/root/.nano.d/puppet.nanorc':
    ensure  => 'file',
    source  => 'puppet:///modules/fundamentals/environment/nano/puppet.nanorc',
  }

  file_line { 'default editor':
    path    => '/root/.bash_profile',
    line    => 'export EDITOR=nano',
    match   => "EDITOR=",
    require => Package['nano'],
  }
}
