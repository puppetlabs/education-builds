class advanced::mcollective::master {
  # Ensure the existence of files in the cache directory so clients can download them
  # Make sure any arrays in config.pp are added to the $files calculation
  include advanced::mcollective::config

  $files = flatten([
    $advanced::mcollective::config::ssl_certs,
    $advanced::mcollective::config::peadmin,
  ])

  # Build an array of all directories that should exist in our cache directory.
  $dirs = prefix(dirtree(dirnames($files)), $advanced::mcollective::config::cachedir)

  file { $advanced::mcollective::config::cachedir:
    ensure => directory,
    owner  => $advanced::mcollective::config::master_user,
    group  => $advanced::mcollective::config::master_group,
    mode   => '0600',
  }

  file { $dirs:
    ensure => directory,
    owner  => $advanced::mcollective::config::master_user,
    group  => $advanced::mcollective::config::master_group,
    mode   => '0600',
  }

  advanced::mcollective::cache { $files:
    ensure => present,
  }
}
