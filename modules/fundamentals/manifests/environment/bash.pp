class fundamentals::environment::bash {
  package { 'bash':
    ensure => present,
  }

  file { '/root/.bashrc':
    source => 'puppet:///modules/fundamentals/environment/bash/bashrc',
  }

  user { 'root':
    ensure  => present,
    shell   => '/bin/bash',
    require => Package['bash'],
  }
}
