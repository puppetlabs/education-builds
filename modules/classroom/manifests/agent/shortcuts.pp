class classroom::agent::shortcuts (
  $timeout = $classroom::params::timeout,
) inherits classroom::params {

  if $::osfamily == 'windows' {
    # Symlinks on desktp
    file { 'C:/Users/Administrator/Desktop/etc':
      ensure  => link,
      target  => 'C:/ProgramData/PuppetLabs/puppet/etc',
    }
    file { 'C:/Users/Administrator/Desktop/puppetcode':
      ensure  => link,
      target  => $classroom::workdir,
      require => File[$classroom::workdir],
    }
  }
  else {
    fail("The Shortcuts Class supports only Windows, not ${::osfamily}")
  }

}
