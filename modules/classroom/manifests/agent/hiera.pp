# Make sure that Hiera is configured for agent nodes so that we
# can work through the hiera sections without teaching them
# how to configure it.
class classroom::agent::hiera (
  $managerepos = $classroom::managerepos,
  $workdir     = $classroom::workdir,
  $etcpath     = $classroom::etcpath,
) inherits classroom {

  # Set defaults depending on os
  case $::osfamily {
    'windows' : {
      File {
        owner => 'Administrator',
        group => 'Users',
      }
    }
    default   : {
      File {
        owner => 'root',
        group => 'root',
        mode  => '0644',
      }
    }
  }

  if $managerepos {
    file { "${etcpath}/hieradata":
      ensure => link,
      target => "${workdir}/hieradata",
    }

    file { "${etcpath}/hiera.yaml":
      ensure => link,
      target => "${workdir}/hiera.yaml",
      force  => true,
    }

    file { "${workdir}/hiera.yaml":
      ensure => file,
      source => 'puppet:///modules/classroom/hiera.agent.yaml',
      replace => false,
    }

  }
  else {
    file { "${etcpath}/hieradata":
      ensure => directory,
    }

    # Because PE writes a default, we cannot use replace => false
    file { "${etcpath}/hiera.yaml":
      ensure => file,
      source => 'puppet:///modules/classroom/hiera.agent.yaml',
    }
  }

  file { "${etcpath}/hieradata/defaults.yaml":
    ensure  => file,
    source  => 'puppet:///modules/classroom/defaults.yaml',
    replace => false,
  }
}
