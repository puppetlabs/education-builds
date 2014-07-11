class userprefs::bash (
  $user     = 'root',
  $homedir  = '/root',
  $default  = true,
  $password = undef,
  $replace  = false,
) {
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
