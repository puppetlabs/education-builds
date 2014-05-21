# This class will build workdirs for each team this student is a member of.
# This will amost always be either zero or one, depending on whether the
# class has reached the Capstone yet. It *does* support placing a student
# on multiple teams, for the off chance that this is useful.
#
# This will also replace the standard modulepath directory with a link to the
# student's workdir modulepath, or that of their team. This allows the seamless
# use of `puppet module install`.
#
# If autosetup is enabled, then this will manage the student's environment
# setting as well.
#
class classroom::agent::teams (
  $autosetup = $classroom::autosetup,
) inherits classroom {

  # If we have teams defined for this student, build a working directory for each.
  $teams = teams($::hostname)
  if $teams {
    classroom::agent::workdir { $teams:
      ensure   => present,
      populate => false,
    }

    # manage if the student is on a single team (almost always the case)
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
