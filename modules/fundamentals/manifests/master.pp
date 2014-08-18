# Set up the master with user accounts, environments, etc
class fundamentals::master ( $classes = [] ) {
  if versioncmp($::pe_version, '3.0.0') == 0 {
    class { 'fundamentals::master::console': }
  }
  File {
    owner => 'root',
    group => 'root',
    mode  => '1777',
  }
  # This requirement is to make sure that storeconfigs is enabled
  # before attempting to realize exported fundamentals::users
  Fundamentals::User {
    require => Service['pe-httpd'],
  }

  # This wonkiness is due to the fact that puppet_enterprise::license class
  # manages this file only if it exists on the master. So we do the opposite.
  if ( file('/etc/puppetlabs/license.key', '/dev/null') == undef ) {
    # Write out our edu license file to prevent console noise
    file { '/etc/puppetlabs/license.key':
      ensure => file,
      source => 'puppet:///modules/fundamentals/license.key',
    }
  }

  package { 'git':
    ensure => present,
  }

  file { ['/var/repositories', '/etc/puppetlabs/puppet/environments']:
    ensure => directory,
  }

  # Ensure the environment cache is disabled and restart if needed
  augeas {'puppet.conf.main':
    context => '/files/etc/puppetlabs/puppet/puppet.conf/main',
    changes => [
      "set environment_timeout 0",
    ],
    notify  => Service['pe-httpd'],
  }

  # Ensure that storeconfigs are enabled and restart if needed
  augeas {'puppet.conf.master':
    context => '/files/etc/puppetlabs/puppet/puppet.conf/master',
    changes => [
      "set storeconfigs true",
    ],
    notify  => Service['pe-httpd'],
  }

  # Some versions of PE manage this service, some don't
  # We only need it managed so we can notify it to restart
  if versioncmp($::fundamentals_pe_version, '2.7.0') != 0 {
    service { 'pe-httpd':
      ensure => running,
      enable => true,
    }
  }

  file_line { 'rubycas_server_console_session_lifetime':
    ensure => present,
    path  => '/etc/puppetlabs/rubycas-server/config.yml',
    match  => '^maximum_session_lifetime:',
    line   => "maximum_session_lifetime: 100000",
    notify => Service['pe-httpd'],
  }

  file_line { 'console_auth_session_lifetime':
    ensure => present,
    path   => '/etc/puppetlabs/console-auth/cas_client_config.yml',
    match  => '\s*session_lifetime:',
    line   => "  session_lifetime: 100000",
    notify => Service['pe-httpd'],
  }

  # configure Hiera environments for the master
  include fundamentals::master::hiera

  # if we've gotten to the Capstone and teams are defined, create our teams!
  $teams = hierasafe('teams', undef)
  if $teams {
    $teamnames = keys($teams)

    # create each team. Pass in the full hash so that team can set its members
    fundamentals::master::team { $teamnames:
      teams => $teams,
    }
  }

  # unselect all nodes in Live Management by default
  #include fundamentals::console::patch

  # Add any classes defined to the console
  fundamentals::console::class { $classes: }

  # Now create all of the users who've checked in
  Fundamentals::User <<||>>
}
