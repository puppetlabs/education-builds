# Set an environment in puppet.conf
# Create the user a bare repository in the repository root
# Create a clone of that repository in the users' puppet environment
# Add a post-commit hook to automatically update the environment on push
define classroom::master::repository (
  $ensure      = present,
  $environment = true,
  $repo_user   = $name,
  $repo_root   = '/var/repositories',
  $clone_root  = '/etc/puppetlabs/puppet/environments',
) {

  if !( $ensure in ['present','absent'] ) {
    fail("classroom::master::repository ensure parameter must be 'present' or 'absent'")
  }

  validate_absolute_path("$repo_root")
  validate_absolute_path("$clone_root")

  # A valid hostname is not necessarily a valid Puppet environment name!
  # Check for valid Puppet environment name.
  validate_re($name, '^[a-zA-Z0-9_]+$')

  File {
    owner => $repo_user,
    group => 'pe-puppet',
  }
  Exec {
    path => '/usr/bin:/bin'
  }
  Vcsrepo {
    provider => git,
    user     => $repo_user,
  }

  if $ensure == present {
    if $environment {
      # create an environment for the user
      augeas {"puppet.conf.environment.${name}":
        context => "/files/etc/puppetlabs/puppet/puppet.conf/${name}",
        changes => [
          "set manifest ${clone_root}/${name}/site.pp",
          "set modulepath ${clone_root}/${name}/modules:/etc/puppetlabs/puppet/modules:/opt/puppet/share/puppet/modules",
        ],
      }
    }

    vcsrepo { "${repo_root}/${name}.git":
      ensure   => bare,
    }

    file { "${repo_root}/${name}.git/hooks/post-update":
      ensure   => file,
      content  => template('classroom/post-update.erb'),
      mode     => '0755',
      require  => Vcsrepo["${repo_root}/${name}.git"],
    }

    vcsrepo { "${clone_root}/${name}":
      ensure    => present,
      source    => "${repo_root}/${name}.git",
      require   => Vcsrepo["${repo_root}/${name}.git"],
    }
  }
  else {
    file { [ "${repo_root}/${name}.git", "${clone_root}/${name}" ]:
      ensure => absent,
    }
  }
}

