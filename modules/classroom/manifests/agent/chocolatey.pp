class classroom::agent::chocolatey (
  $timeout = $classroom::params::timeout,
) inherits classroom::params {

  if $::osfamily == 'windows' {
    exec { 'install-chocolatey':
      command  => '( iex ((new-object net.webclient).DownloadString("https://chocolatey.org/install.ps1")) ) >$null 2>&1',
      creates  => ['C:\Chocolatey','C:\ProgramData\chocolatey'],
      provider => powershell,
      timeout  => $timeout,
    }
  }
  else {
    fail("Chocolatey supports only Windows, not ${::osfamily}")
  }

}
