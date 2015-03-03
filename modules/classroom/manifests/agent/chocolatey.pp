class classroom::agent::chocolatey (
  $timeout = $classroom::params::timeout,
) inherits classroom::params {

  if $::osfamily == 'windows' {
    file { 'C:\install.ps1':
      source => 'puppet:///modules/classroom/install.ps1',
    }
    exec { 'install-chocolatey':
      command  => 'C:\install.ps1 >$null 2>&1',
      creates  => ['C:\Chocolatey','C:\ProgramData\chocolatey'],
      provider => powershell,
      timeout  => $timeout,
    }
  }
  else {
    fail("Chocolatey supports only Windows, not ${::osfamily}")
  }

}
