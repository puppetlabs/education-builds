class userprefs::zsh (
  $user     = 'root',
  $group    = 'root',
  $homedir  = '/root',
  $default  = true,
  $password = undef,
) {
  File {
    owner => $user,
    group => $group,
    mode  => '0644',
  }

  package { 'zsh':
    ensure => present,
  }

  # zsh doesn't source .profile by default.
  file { "${homedir}/.zprofile":
    ensure  => 'file',
    replace => false, # allow users to customize their .profile
    source  => 'puppet:///modules/userprefs/shell/zprofile',
    require => Package['zsh'],
  }

  file { "${homedir}/.zshrc":
    ensure  => file,
    replace => false,
    source  => 'puppet:///modules/userprefs/shell/zshrc',
    require => Package['zsh'],
  }

  file { "${homedir}/.zshrc.puppet":
    ensure  => file,
    source  => 'puppet:///modules/userprefs/shell/zshrc.puppet',
    require => Package['zsh'],
  }

  if $default {
    user { $user:
      ensure   => present,
      shell    => '/bin/zsh',
      password => $password,
      require  => Package['zsh'],
    }
  }
}
