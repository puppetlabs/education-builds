class fundamentals::environment::zsh {
  package { 'zsh':
    ensure => present,
  }

  file { '/root/.zshrc':
    source => 'puppet:///modules/fundamentals/environment/zsh/zshrc',
  }

  user { 'root':
    ensure  => present,
    shell   => '/bin/zsh',
    require => Package['zsh'],
  }
}
