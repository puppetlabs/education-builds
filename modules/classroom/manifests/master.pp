# Set up the master with user accounts, environments, etc
class classroom::master (
  $classes  = classroom::params::classes,
  $offline  = classroom::params::offline,
  $autoteam = $classroom::params::autoteam,
) inherits classroom::params {

  File {
    owner => 'root',
    group => 'root',
    mode  => '1777',
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

  # configure Hiera environments for the master
  class { 'classroom::master::hiera':
    autoteam => $autoteam,
  }

  # if we've gotten to the Capstone and teams are defined, create our teams!
  $teams = hierasafe('teams', undef)
  if $teams {
    $teamnames = keys($teams)

    # create each team. Pass in the full hash so that team can set its members
    classroom::master::team { $teamnames:
      teams => $teams,
    }
  }

  # Ensure that time is set appropriately
  class { 'classroom::master::time':
    offline => $offline,
  }

  # unselect all nodes in Live Management by default
  #include classroom::console::patch

  # Add any classes defined to the console
  classroom::console::class { $classes: }

  # Now create all of the users who've checked in
  Classroom::User <<||>>
}
