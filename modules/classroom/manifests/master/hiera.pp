# Make sure that Hiera is configured for the master so that we
# enabling the use of Hiera within student environments.
#
# Paramters:
# * $autoteam: automatically create simple teams for Capstone. Defaults to false.
#
class classroom::master::hiera (
  $autoteam = $classroom::autoteam,
) inherits classroom {
  validate_bool($autoteam)

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { '/etc/puppetlabs/puppet/hieradata':
    ensure => directory,
  }

  file { '/etc/puppetlabs/puppet/hieradata/defaults.yaml':
    ensure  => file,
    source  => 'puppet:///modules/classroom/defaults.yaml',
    replace => false,
  }

  # place the environments link in place only on the master
  file { '/etc/puppetlabs/puppet/hieradata/environments':
    ensure => link,
    target => '/etc/puppetlabs/puppet/environments',
  }

  file { '/etc/puppetlabs/puppet/hiera.yaml':
    ensure => file,
    source => 'puppet:///modules/classroom/hiera.master.yaml',
  }

  if $autoteam {
    file { '/etc/puppetlabs/puppet/hieradata/teams.yaml':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('classroom/teams.yaml.erb'),
      replace => false,
    }
  }
}
