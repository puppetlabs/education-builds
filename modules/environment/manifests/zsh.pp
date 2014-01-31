class environment::zsh (
  $default = true,
) {
  package { 'zsh':
    ensure => present,
  }

  file { '/root/.zprofile':
    ensure => link,
    target => '/root/.profile',
  }

  if $default {
    user { 'root':
      ensure  => present,
      shell   => '/bin/zsh',
      require => Package['zsh'],
    }
  }
}
