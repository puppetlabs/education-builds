class advanced::mcollective::master {
  # Ensure the existence of files in the cache directory so clients can download them
  # Make sure any arrays in config.pp are added to the $files calculation
  include advanced::mcollective::config
  include pe_mcollective

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

  # We need to set the following console parameters so that the student machines
  # will be configured to talk to the classroom ActiveMQ server, even when running
  # against their own masters.
  # The susbcribe is to ensure it only runs once after classifying classroom
  $stomp_server   = $advanced::mcollective::config::stomp_server
  $stomp_password = chomp(file("${pe_mcollective::params::mco_etc}/credentials"))

  Exec {
    path        => '/opt/puppet/bin:/bin',
    cwd         => '/opt/puppet/share/puppet-dashboard',
    environment => 'RAILS_ENV=production',
    returns     => '0',
    subscribe   => File[$advanced::mcollective::config::cachedir],
    refreshonly => true,
  }

  exec { 'node:parameters:fact_stomp_server':
    command     => "rake nodegroup:parameters name=default parameters=fact_stomp_server=${stomp_server}",
  }

  exec { 'node:parameters:stomp_password':
    command     => "rake nodegroup:parameters name=default parameters=stomp_password=${stomp_password}",
  }

}
