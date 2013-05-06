# Set an environment in puppet.conf
# Create the user a bare repository in the repository root
# Create a clone of that repository in the users' puppet environment
# Add a post-commit hook to automatically update the environment on push
define fundamentals::master::repository (
  $ensure  = present,
  $root    = '/var/repositories',
  $envroot = '/etc/puppetlabs/puppet/environments',
) {
  File {
    owner => $name,
    group => 'pe-puppet',
  }
  Exec {
    path => '/usr/bin:/bin'
  }

  if $ensure == present {
    # create an environment for the user
    augeas {"puppet.conf.environment.${name}":
      context => "/files/etc/puppetlabs/puppet/puppet.conf/${name}",
      changes => [
        "set manifest ${envroot}/${name}/site.pp",
        "set modulepath ${envroot}/${name}/modules:/opt/puppet/share/puppet/modules",
      ],
    }

    # requires my patch: https://github.com/puppetlabs/puppetlabs-vcsrepo/pull/57
    vcsrepo { "${root}/${name}.git":
      ensure   => bare,
      provider => git,
      user     => $name,
      require  => User[$name],
    }

    file { "${root}/${name}.git/hooks/post-update":
      ensure   => file,
      content  => template('fundamentals/post-update.erb'),
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

