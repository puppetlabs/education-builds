# This class configures the agent with
#  * root sshkey
#  * git source repository
#  * git pre-commit hook
class fundamentals::agent ( $workdir = 'puppetcode' ) {
  Exec {
    environment => 'HOME=/root',
    path        => '/usr/bin:/bin:/user/sbin:/usr/sbin',
  }

  package { 'git':
    ensure => present,
  }

  file { '/root/.ssh':
    ensure => directory,
    mode   => '0600',
  }

  exec { 'generate_key':
    command => 'ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa',
    creates => '/root/.ssh/id_rsa',
    require => File['/root/.ssh'],
  }

  exec { "git config --global user.name '${::hostname}'":
    unless  => 'git config --global user.name',
    require => Package['git'],
  }

  exec { "git config --global user.email ${::hostname}@puppetlabs.vm":
    unless  => 'git config --global user.email',
    require => Package['git'],
  }

  # /etc/puppet/ssl is confusing to have around. Sloppy. Kill.
  file {'/etc/puppet':
    ensure  => absent,
    recurse => true,
    force   => true,
  }

  fundamentals::agent::workdir { $workdir:
    ensure   => present,
    username => $::hostname,
  }

  # If we have teams defined, build a working directory for each.
  $teams = teams($::hostname)
  if $teams {
    fundamentals::agent::workdir { $teams:
      ensure   => present,
      populate => false,
    }
  } else {
    # If we don't have teams, enforce the symlink. When they get to
    # the capstone, they should know how to manage this on their own.
    # create a symlink to allow local puppet use
    file { '/etc/puppetlabs/puppet/modules':
      ensure => link,
      target => "/root/${workdir}/modules",
      force  => true,
    }
  }

  # export a fundamentals::user with our ssh key.
  #
  # !!!! THIS WILL EXPORT AN EMPTY KEY ON THE FIRST RUN !!!!
  #
  # On the second run, the ssh key will exist and so this fact will be set.
  @@fundamentals::user { $::hostname:
    key => $::root_ssh_key,
  }
}

