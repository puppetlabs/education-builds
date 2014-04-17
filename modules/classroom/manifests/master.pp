# Set up the master with user accounts, environments, etc
class classroom::master ( $classes = [] ) {
  if versioncmp($::pe_version, '3.0.0') == 0 {
    class { 'classroom::master::console': }
  }
  File {
    owner => 'root',
    group => 'root',
    mode  => '1777',
  }
  # This requirement is to make sure that storeconfigs is enabled
  # before attempting to realize exported classroom::users
  Fundamentals::User {
    require => Service['pe-httpd'],
  }

  # This wonkiness is due to the fact that puppet_enterprise::license class
  # manages this file only if it exists on the master. So we do the opposite.
  if ( file('/etc/puppetlabs/license.key', '/dev/null') == undef ) {
    # Write out our edu license file to prevent console noise
    file { '/etc/puppetlabs/license.key':
      ensure => file,
      source => 'puppet:///modules/classroom/license.key',
    }
  }

  package { 'git':
    ensure => present,
  }

  file { ['/var/repositories', '/etc/puppetlabs/puppet/environments']:
    ensure => directory,
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
  if versioncmp($::classroom_pe_version, '2.7.0') != 0 {
    service { 'pe-httpd':
      ensure => running,
      enable => true,
    }
  }

  # configure Hiera environments for the master
  include classroom::master::hiera

  # if we've gotten to the Capstone and teams are defined, create our teams!
  $teams = hierasafe('teams', undef)
  if $teams {
    $teamnames = keys($teams)

    # create each team. Pass in the full hash so that team can set its members
    classroom::master::team { $teamnames:
      teams => $teams,
    }
  }

  # unselect all nodes in Live Management by default
  #include classroom::console::patch

  # Add any classes defined to the console
  classroom::console::class { $classes: }

  # Now create all of the users who've checked in
  Fundamentals::User <<||>>
}
