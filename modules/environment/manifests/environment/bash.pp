class environment::bash {
  package { 'bash':
    ensure => present,
  }

  user { 'root':
    ensure  => present,
    shell   => '/bin/bash',
    require => Package['bash'],
  }
}
