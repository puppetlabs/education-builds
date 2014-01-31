class userprefs::bash (
  $default = true,
) {
  package { 'bash':
    ensure => present,
  }

  if $default {
    user { 'root':
      ensure  => present,
      shell   => '/bin/bash',
      require => Package['bash'],
    }
  }
}
