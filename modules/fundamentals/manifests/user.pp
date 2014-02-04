# Create a classroom user on the master
define fundamentals::user (
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

  # A valid hostname is not necessarily a valid Puppet environment name!
  validate_re($name, '^(?=.*[a-z])\A[a-z0-9][a-z0-9._]+\z', "The classroom environment supports alphanumeric hostnames only. ${name} is not a valid name. Please ask your instructor for assistance.")

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

  if $key {
    ssh_authorized_key { $name:
      key     => $key,
      type    => 'ssh-rsa',
      user    => $name,
      require => File["/home/${name}/.ssh"],
    }
  }

  if $console_password {
    fundamentals::console::user { $name:
      password => $console_password,
    }
  }

  fundamentals::master::repository { $name:
    ensure => present,
  }

}
