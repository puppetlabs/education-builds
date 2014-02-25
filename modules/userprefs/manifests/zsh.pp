class userprefs::zsh (
  $default  = true,
  $password = undef,
) {
  package { 'zsh':
    ensure => present,
  }

  # zsh doesn't source .profile by default.
  file { '/root/.zprofile':
    ensure  => 'file',
    replace => false, # allow users to customize their .profile
    source  => 'puppet:///modules/userprefs/shell/zprofile',
    require => Package['zsh'],
  }

  file { '/root/.zshrc':
    ensure  => file,
    replace => false,
    source  => 'puppet:///modules/userprefs/shell/zshrc',
    require => Package['zsh'],
  }

  file { '/root/.zshrc.puppet':
    ensure  => file,
    source  => 'puppet:///modules/userprefs/shell/zshrc.puppet',
    require => Package['zsh'],
  }

  if $default {
    user { 'root':
      ensure   => present,
      shell    => '/bin/zsh',
      password => $password,
      require  => Package['zsh'],
    }
  }
}
