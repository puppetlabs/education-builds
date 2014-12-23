class classroom::agent::notepad (
  $timeout = $classroom::params::timeout,
) inherits classroom::params {

  if $::osfamily == 'windows' {
    package { 'notepadplusplus':
      ensure => present,
      provider => 'chocolatey',
      require => Class['classroom::agent::chocolatey'],
    }
  }
  else {
    fail("Notepad++ supports only Windows, not ${::osfamily}")
  }

}
