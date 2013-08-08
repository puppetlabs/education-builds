# Configure the Fundamentals classroom environment.
#
# fundamentals::agent
#   * set up the agent with an sshkey for root
#   * set up a git working directory for the user
#   * point a git remote to the repo on the puppet master
#   * export a fundamentals::user account
#       * this depends on a root_ssh_key fact so this user
#         account won't be exported properly on first run
#
# fundamentals::master
#   * prepares the master's environment
#   * creates a git repository root
#   * creates an environment root for checking out working copies
#   * instantiate all exported fundamentals::users
#       * creates a shell user with ssh key
#       * creates a puppet.conf environment fragment
#       * creates a bare repository in repo root
#       * checks out a working copy in the environments root
#
class fundamentals {

  if $::fact_is_puppetmaster == 'true' {

    # define a list of classes that should be available in the console
    class { 'fundamentals::master':
      classes => [ 'users', 'apache' ]
    }
  }
  else {
    include fundamentals::agent
  }

}
