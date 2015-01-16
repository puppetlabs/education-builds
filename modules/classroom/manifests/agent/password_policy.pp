class classroom::agent::password_policy (
  $timeout = $classroom::params::timeout,
) inherits classroom::params {

  if $::osfamily == 'windows' {
    # Disable draconian password policy
    exec { 'ExportSecurityPolicy':
      command     => 'secedit /export /cfg c:\windows\temp\secpol.cfg',
      provider    => powershell,
      creates     => 'c:/windows/temp/secpol.cfg',
    }
    exec { 'EditPasswordComplexity':
      command     => '(gc C:/windows/temp/secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0")',
      unless      => 'if((gc C:/windows/temp/secpol.cfg |grep "PasswordComplexity").split("=")[1] -gt 0){exit 1}',
      provider    => powershell,
      subscribe   => Exec['ExportSecurityPolicy'],
      refreshonly => true,
    }
    exec { 'EditPasswordLength':
      command     => '(gc C:/windows/temp/secpol.cfg).replace("MinimumPasswordLength = *", "MinimumPasswordLength = 1")',
      unless      => 'if((gc C:/windows/temp/secpol.cfg |grep "PasswordLength").split("=")[1] -gt 1){exit 1}',
      provider    => powershell,
      subscribe   => Exec['EditPasswordComplexity'],
      refreshonly => true,
    }
    exec { 'ApplySecurityPolicy':
      command     => 'secedit /configure /db c:\windows\security\local.sdb /cfg c:\windows\temp\secpol.cfg /areas SECURITYPOLICY',
      provider    => powershell,
      subscribe   => Exec['EditPasswordLength'],
      refreshonly => true,
    }
    else {
      fail("The Password Policy Class supports only Windows, not ${::osfamily}")
    }
  }
}
