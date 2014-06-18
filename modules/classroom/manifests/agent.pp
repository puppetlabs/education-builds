# This class configures the agent with
#  * root sshkey
#  * git source repository
#  * git pre-commit hook
#  * hiera configuration
#  * time synchronization with the classroom master
class classroom::agent (
  $workdir   = $classroom::workdir,
  $autosetup = $classroom::autosetup,
) inherits classroom {

  # make sure our git environment is set up and usable
  include classroom::agent::git

  classroom::agent::workdir { $workdir:
    ensure   => present,
    username => $::hostname,
    require  => Class['classroom::agent::git'],
  }

  # Make sure that Hiera is configured for all nodes so that we
  # can work through the hiera sections without teaching them
  # how to configure it.
  include classroom::agent::hiera

  # Ensure that the time is always synced with the classroom master
  include classroom::agent::time

  # If we have teams defined for this node, build a working directory for each.
  include classroom::agent::teams

  # export a classroom::user with our ssh key.
  #
  # !!!! THIS WILL EXPORT AN EMPTY KEY ON THE FIRST RUN !!!!
  #
  # On the second run, the ssh key will exist and so this fact will be set.
  @@classroom::user { $::hostname:
    key => $::root_ssh_key,
  }

  # /etc/puppet/ssl is confusing to have around. Sloppy. Kill.
  file {'/etc/puppet':
    ensure  => absent,
    recurse => true,
    force   => true,
  }
}
