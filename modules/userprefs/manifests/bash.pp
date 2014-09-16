class userprefs::bash (
  $user     = 'root',
  $group    = 'root',
  $homedir  = '/root',
  $default  = true,
  $password = undef,
  $replace  = false,
) {
  File {
    owner => $user,
    group => $group,
    mode  => '0644',
  }

  package { 'bash':
    ensure => present,
  }

  file { "${homedir}/.bashrc":
    ensure  => file,
    replace => $replace,
    source  => 'puppet:///modules/userprefs/shell/bashrc',
    require => Package['bash'],
  }

  file { "${homedir}/.bash_profile":
    ensure  => file,
    replace => $replace,
    source  => 'puppet:///modules/userprefs/shell/bash_profile',
    require => Package['bash'],
  }

  file { "${homedir}/.bashrc.puppet":
    ensure  => file,
    content => template('userprefs/bashrc.puppet.erb'),
    require => Package['bash'],
  }

  if $default {
    user { $user:
      ensure   => present,
      shell    => '/bin/bash',
      password => $password,
      require  => Package['bash'],
    }
  }
}
