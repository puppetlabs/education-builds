class environment::zsh {
  package { 'zsh':
    ensure => present,
  }

  file { '/root/.zprofile':
    ensure => link,
    target => '/root/.profile',
  }

  user { 'root':
    ensure  => present,
    shell   => '/bin/zsh',
    require => Package['zsh'],
  }
}
