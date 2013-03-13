# Create a classroom user on the master
define fundamentals::user(
  $key = undef,
  # Password defaults to puppetlabs
  $password='$1$Tge1IxzI$kyx2gPUvWmXwrCQrac8/m0',
  $console_password='puppetlabs'
) {
  File {
    owner => $name,
    group => 'pe-puppet',
    mode  => '0644',
  }

  user { $name:
    ensure   => present,
    gid      => 'pe-puppet',
    password => $password,
    home     => "/home/${name}",
  }

  file { "/home/${name}":
    ensure => directory,
  }

  file { "/home/${name}/.ssh":
    ensure => directory,
    mode   => '0600',
  }

  ssh_authorized_key { $name:
    key     => $key,
    type    => 'ssh-rsa',
    user    => $name,
    require => File["/home/${name}/.ssh"],
  }

  # create an environment for the user
  augeas {"puppet.conf.environment.${name}":
    context => "/files/etc/puppetlabs/puppet/puppet.conf/${name}",
    changes => [
      "set manifest /etc/puppetlabs/puppet/environments/${name}/site.pp",
      "set modulepath /etc/puppetlabs/puppet/environments/${name}:/opt/puppet/share/puppet/modules",
    ],
  }

  fundamentals::console::user { $name:
    password => $console_password,
  }

  fundamentals::repository { $name:
    ensure => present,
  }
}
