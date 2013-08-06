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
