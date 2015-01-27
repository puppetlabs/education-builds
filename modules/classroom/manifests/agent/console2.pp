class classroom::agent::console2 (
  $timeout = $classroom::params::timeout,
) inherits classroom::params {

  if $::osfamily == 'windows' {
    package { 'console2':
      ensure => present,
      provider => 'chocolatey',
      require => Class['classroom::agent::chocolatey'],
    }
  }
  else {
    fail("console2 supports only Windows, not ${::osfamily}")
  }

}
