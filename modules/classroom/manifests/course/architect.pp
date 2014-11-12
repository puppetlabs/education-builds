# This is a wrapper class to include all the bits needed for Architect
#
class classroom::course::architect (
  $offline   = $classroom::params::offline,
  $autosetup = $classroom::params::autosetup,
  $autoteam  = $classroom::params::autoteam,
  $role      = $classroom::params::role,
  $manageyum = $classroom::params::manageyum,
) inherits classroom::params {
  # just wrap the classroom class
  class { 'classroom':
    offline     => $offline,
    autosetup   => $autosetup,
    autoteam    => $autoteam,
    role        => $role,
    manageyum   => $manageyum,
    managerepos => false,
  }

  if $role == 'master' {
    # master gets the IRC server and reporting scripts
    include classroom::master::ircd
    include classroom::master::puppetdb

    # Include the Irssi setup and collect all hosts
    include classroom::agent::irc
    include classroom::agent::hosts

    # Configure the classroom so that any secondary masters will get the
    # agent tarball from the classroom master.
    include classroom::master::agent_tarball
  }
  elsif $role == 'agent' {
    # tools used in class
    include classroom::agent::r10k
    include classroom::master::reporting_tools

    # Include the Irssi setup and collect all hosts
    include classroom::agent::irc
    include classroom::agent::hosts

    # The student masters should export a balancermember
    include classroom::master::balancermember

    # The autoscaling seems to assume that you'll sync this out from the MoM
    include classroom::master::student_environment
  }

  # manual fiddling not needed on current PE
  if versioncmp($::pe_version, '3.4.0') < 0 {
    include classroom::mcollective
  }
}
