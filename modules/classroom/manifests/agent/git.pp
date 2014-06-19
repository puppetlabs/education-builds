class classroom::agent::git {
  Exec {
    environment => 'HOME=/root',
    path        => '/usr/bin:/bin:/user/sbin:/usr/sbin',
  }

  include git

  file { '/root/.ssh':
    ensure => directory,
    mode   => '0600',
  }

  exec { 'generate_key':
    command => 'ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa',
    creates => '/root/.ssh/id_rsa',
    require => File['/root/.ssh'],
  }

  exec { "git config --global user.name '${::hostname}'":
    unless  => 'git config --global user.name',
    require => Package['git'],
  }

  exec { "git config --global user.email ${::hostname}@puppetlabs.vm":
    unless  => 'git config --global user.email',
    require => Package['git'],
  }
}
