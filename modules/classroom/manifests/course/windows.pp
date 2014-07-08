# This is a wrapper class to include all the bits needed for Fundamentals
#
class classroom::course::windows (
  $offline   = $classroom::params::offline,
  $autosetup = $classroom::params::autosetup,
  $autoteam  = $classroom::params::autoteam,
  $role      = $classroom::params::role,
  $manageyum = $classroom::params::manageyum,
) inherits classroom::params {

  # Admin user for consistency
  user { 'Administrator':
    ensure => present,
    groups => ['Administrators'],
  }

#   exec { 'install Chocolatey':
#     command  => "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))",
#     provider => 'powershell',
#     creates  => 'C:\Chocolatey',
#   }
#
#   windows_env {'ChocolateyInstall':
#   	ensure    => present,
#   	mergemode => clobber,
#   	value     => 'C:\Chocolatey',
#   	require   => Exec['install Chocolatey'],
#   }
#
#   windows_env {'PATH':
#   	ensure    => present,
#   	mergemode => append,
#   	value     => '%systemdrive%\chocolatey\bin',
#   	require   => Exec['install Chocolatey'],
#   }

  # just wrap the classroom class
  class { 'classroom':
    offline   => $offline,
    autosetup => $autosetup,
    autoteam  => $autoteam,
    role      => $role,
    manageyum => $manageyum,
#    require   => Windows_env['PATH'],
  }
}
