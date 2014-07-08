class classroom::mcollective::master {
  # Ensure the existence of files in the cache directory so clients can download them
  # Make sure any arrays in config.pp are added to the $files calculation
  include classroom::mcollective::config
  include pe_mcollective

  $files = flatten([
    $classroom::mcollective::config::ssl_certs,
    $classroom::mcollective::config::peadmin,
  ])

  # Build an array of all directories that should exist in our cache directory.
  $dirs = prefix(dirtree(dirnames($files)), $classroom::mcollective::config::cachedir)

  file { $classroom::mcollective::config::cachedir:
    ensure => directory,
    owner  => $classroom::mcollective::config::master_user,
    group  => $classroom::mcollective::config::master_group,
    mode   => '0600',
  }

  file { $dirs:
    ensure => directory,
    owner  => $classroom::mcollective::config::master_user,
    group  => $classroom::mcollective::config::master_group,
    mode   => '0600',
  }

  classroom::mcollective::cache { $files:
    ensure => present,
  }

  # We need to set the following console parameters so that the student machines
  # will be configured to talk to the classroom ActiveMQ server, even when running
  # against their own masters.
  # The susbcribe is to ensure it only runs once after classifying classroom
  $stomp_server   = $classroom::mcollective::config::stomp_server
  $stomp_password = chomp(file("${pe_mcollective::params::mco_etc}/credentials"))

  Exec {
    path        => '/opt/puppet/bin:/bin',
    cwd         => '/opt/puppet/share/puppet-dashboard',
    environment => 'RAILS_ENV=production',
    returns     => '0',
    subscribe   => File[$classroom::mcollective::config::cachedir],
    refreshonly => true,
  }

  exec { 'node:parameters:fact_stomp_server':
    command     => "rake nodegroup:parameters name=default parameters=fact_stomp_server=${stomp_server}",
  }

  exec { 'node:parameters:stomp_password':
    command     => "rake nodegroup:parameters name=default parameters=stomp_password=${stomp_password}",
  }

}
