# Set up the master with user accounts, environments, etc
class classroom::master (
  $classes     = $classroom::classes,
  $offline     = $classroom::offline,
  $autoteam    = $classroom::autoteam,
  $managerepos = $classroom::managerepos,
) inherits classroom {

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

  # if configured to do so, configure repos & environments on the master
  if $managerepos {
    include classroom::master::repositories
  }

  # Ensure that time is set appropriately
  include classroom::master::time

  # unselect all nodes in Live Management by default
  #include classroom::console::patch

  # Add any classes defined to the console
  classroom::console::class { $classes: }

  # Now create all of the users who've checked in
  Classroom::User <<||>>
}
