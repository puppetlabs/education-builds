# Create the user a bare repository in the repository root
# Create a clone of that repository in the users' puppet environment
# Add a post-commit hook to automatically update the environment on push
define classroom::master::repository (
  $ensure  = present,
  $root    = '/var/repositories',
  $envroot = '/etc/puppetlabs/puppet/environments',
) {

  if !( $ensure in ['present','absent'] ) {
    fail("classroom::master::repository ensure parameter must be 'present' or 'absent'")
  }

  validate_absolute_path("$root")
  validate_absolute_path("$envroot")

  # A valid hostname is not necessarily a valid Puppet environment name!
  # Check for valid Puppet environment name.
  validate_re($name, '^[a-zA-Z0-9_]+$')

  File {
    owner => $name,
    group => 'pe-puppet',
  }
  Exec {
    path => '/usr/bin:/bin'
  }

  if $ensure == present {
    # requires my patch: https://github.com/puppetlabs/puppetlabs-vcsrepo/pull/57
    vcsrepo { "${root}/${name}.git":
      ensure   => bare,
      provider => git,
      user     => $name,
      require  => User[$name],
    }

    file { "${root}/${name}.git/hooks/post-update":
      ensure   => file,
      content  => template('classroom/post-update.erb'),
      mode     => '0755',
      require  => Vcsrepo["${root}/${name}.git"],
    }

    # requires patch at https://github.com/puppetlabs/puppetlabs-vcsrepo/pull/42
    vcsrepo { "${envroot}/${name}":
      ensure    => present,
      provider  => git,
      user      => $name,
      source    => "${root}/${name}.git",
      require   => Vcsrepo["${root}/${name}.git"],
    }
  }
  else {
    file { [ "${root}/${name}.git", "${envroot}/${name}" ]:
      ensure => absent,
    }
  }
}

