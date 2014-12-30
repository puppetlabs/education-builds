# This class configures the agent with
#  * root sshkey
#  * git source repository
#  * git pre-commit hook
#  * hiera configuration
#  * time synchronization with the classroom master
class classroom::agent (
  $workdir     = $classroom::workdir,
  $autosetup   = $classroom::autosetup,
  $managerepos = $classroom::managerepos,
  $password    = $classroom::password,
  $consolepw   = $classroom::consolepw,
) inherits classroom {
  # A valid clientcert is not necessarily a valid Puppet environment name!
  validate_re($::clientcert, '^(?=.*[a-z])\A[a-z0-9][a-z0-9._]+\z', "The classroom environment supports lowercase alphanumeric names only. ${name} is not a valid name. Please ask your instructor for assistance.")

  # make sure our git environment is set up and usable
  include classroom::agent::git

  # Make sure that Hiera is configured for all nodes so that we
  # can work through the hiera sections without teaching them
  # how to configure it.
  include classroom::agent::hiera

  # Ensure that the time is always synced with the classroom master
  include classroom::agent::time

  # export a classroom::user with our ssh key.
  #
  # !!!! THIS WILL EXPORT AN EMPTY KEY ON THE FIRST RUN !!!!
  #
  # On the second run, the ssh key will exist and so this fact will be set.
  @@classroom::user { $::hostname:
    key        => $::root_ssh_key,
    password   => $password,
    consolepw  => $consolepw,
    managerepo => $managerepos,
  }

  # if we are managing git repositories, then build out all this
  if $managerepos {
    
    classroom::agent::workdir { $workdir:
      ensure   => present,
      username => $classroom::param::machine_name,
      require  => Class['classroom::agent::git'],
    }

    # If we have teams defined for this node, build a working directory for each.
    include classroom::agent::teams
  }

  # /etc/puppet/ssl is confusing to have around. Sloppy. Kill.
  unless $::osfamily == 'windows' {
    file {'/etc/puppet':
      ensure  => absent,
      recurse => true,
      force   => true,
    }
  }

  # windows goodies
  if $::osfamily  == 'windows' {
    include classroom::agent::chocolatey
    include userprefs::npp
    include classroom::agent::console2
  }
}
