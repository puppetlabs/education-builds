# Configure the training classroom environment.
#
# classroom::agent
#   * set up the agent with an sshkey for root
#   * set up a git working directory for the user
#   * point a git remote to the repo on the puppet master
#   * export a classroom::user account
#       * this depends on a root_ssh_key fact so this user
#         account won't be exported properly on first run
#
# classroom::master
#   * prepares the master's environment
#   * creates a git repository root
#   * creates an environment root for checking out working copies
#   * instantiate all exported classroom::users
#       * creates a shell user with ssh key
#       * creates a puppet.conf environment fragment
#       * creates a bare repository in repo root
#       * checks out a working copy in the environments root
#
#
# $offline   : Configure NTP (and other services) to run in standalone mode
# $autosetup : Automatically configure environment, etc.
# $role      : What classroom role this node should play
#
class classroom (
  $offline      = $classroom::params::offline,
  $autosetup    = $classroom::params::autosetup,
  $autoteam     = $classroom::params::autoteam,
  $role         = $classroom::params::role,
  $manageyum    = $classroom::params::manageyum,
  $managerepos  = $classroom::params::managerepos,
  $time_servers = $classroom::params::time_servers,
  $workdir      = $classroom::params::workdir,
  $password     = $classroom::params::password,
  $consolepw    = $classroom::params::consolepw,
  $etcpath      = $classroom::params::etcpath,
) inherits classroom::params {

  # variables are available to included classes by the evil power of inheritance
  case $role {
    'master' : { include classroom::master }
    'agent'  : { include classroom::agent  }
    'proxy'  : { include classroom::proxy  }
    'tier3'  : { include classroom::tier3  }
    default  : { fail("Unknown role: ${role}") }
  }

  include classroom::repositories
}
