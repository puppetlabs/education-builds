# This is a wrapper class to include all the bits needed for Practitioner
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

    # prepare mcollective certs & config for syncronization
    include classroom::mcollective::master

    # Include the Irssi setup and collect all hosts
    include classroom::agent::irc
    include classroom::agent::hosts
  }
  elsif $role == 'agent' {
    # synchronize mcollective certs & config to client node
    include classroom::mcollective::client
    include classroom::agent::r10k
    include classroom::master::reporting_tools

    # Include the Irssi setup and collect all hosts
    include classroom::agent::irc
    include classroom::agent::hosts
  }
}

