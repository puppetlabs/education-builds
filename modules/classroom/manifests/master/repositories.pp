# This class just manages all the git repositories on the master.
# If it is included, hiera will be configured with environment
# support, the environments directory will be managed and if
# teams are defined, their repositories will be managed.
class classroom::master::repositories {
  File {
    owner => 'root',
    group => 'root',
    mode  => '1777',
  }

  include git

  file { ['/var/repositories', '/etc/puppetlabs/puppet/environments']:
    ensure => directory,
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
}