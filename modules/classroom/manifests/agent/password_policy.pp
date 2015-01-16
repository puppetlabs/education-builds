class classroom::agent::password_policy (
  $timeout = $classroom::params::timeout,
) inherits classroom::params {

  if $::osfamily == 'windows' {
    # Disable draconian password policy
    exec { 'ExportSecurityPolicy':
      command => 'secedit /export /cfg c:\windows\temp\secpol.cfg.orig',
      provider => powershell,
      creates => 'c:/windows/temp/secpol.cfg.orig',
    }
    exec { 'EditPasswordPolicy':
      command => '((((gc C:/windows/temp/secpol.cfg.orig) -replace "PasswordComplexity.*", "PasswordComplexity = 0") -replace "MinimumPasswordLength.*", "MinimumPasswordLength = 1" ) -replace "PasswordHistory.*", "PasswordHistorySize = 0") | set-content c:/windows/temp/secpol.cfg',
      creates => 'c:/windows/temp/secpol.cfg',
      provider => powershell,
      subscribe => Exec['ExportSecurityPolicy'],
      refreshonly => true,
    }
    exec { 'ApplySecurityPolicy':
      command => 'secedit /configure /db c:\windows\security\local.sdb /cfg c:\windows\temp\secpol.cfg /areas SECURITYPOLICY',
      provider => powershell,
      subscribe => Exec['EditPasswordPolicy'],
      refreshonly => true,
    }
  }
  else {
    fail("The Password Policy Class supports only Windows, not ${::osfamily}")
  }

}
