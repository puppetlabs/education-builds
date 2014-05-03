class classroom::agent::teams {
  # If we have teams defined, build a working directory for each.
  $teams = teams($::hostname)
  if $teams {
    classroom::agent::workdir { $teams:
      ensure   => present,
      populate => false,
    }

    if(size($teams) == 1) {
      $team = $teams[0]

      file { '/etc/puppetlabs/puppet/modules':
        ensure => link,
        target => "/root/${team}/modules",
        force  => true,
      }

      if $autosetup {
        ini_setting { "environment":
          ensure  => present,
          path    => '/etc/puppetlabs/puppet/puppet.conf',
          section => 'agent',
          setting => 'environment',
          value   => $team,
        }
      }
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

    if $autosetup {
      ini_setting { "environment":
        ensure  => present,
        path    => '/etc/puppetlabs/puppet/puppet.conf',
        section => 'agent',
        setting => 'environment',
        value   => $::hostname,
      }
    }
  }
}
