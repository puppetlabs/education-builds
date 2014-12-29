class classroom::agent::git {
  case $::osfamily {
    'windows' : {
      $environment = undef
      $path = 'C:/Program Files (x86)/Git/bin'
      $sshpath = 'C:/Program Files (x86)/Git/.ssh'
    }
    default   : {
      $environment = 'HOME=/root'
      $path = '/usr/bin:/bin:/user/sbin:/usr/sbin'
      $sshpath = '/root/.ssh'
    }
  }
  Exec {
    environment => $environment,
    path        => $path,
  }

  if $::osfamily == 'windows'{
    Package { provider => 'chocolatey' }
    package { 'git':
      ensure => present,
      before => [ File[$sshpath], Exec['generate_key'] ],
    }

    package { 'gitextensions':
      ensure => present,
    }
    package { 'kdiff3':
      ensure => present,
    }

    package { 'poshgit':
      ensure => present,
    }

    file { 'C:/Users/Administrator/.ssh/':
      ensure => directory,
      source => $sshppath,
      recurse => true,
      require => [File[$sshpath],Exec['generate_key'],User['Administrator']],
    }
  }
  else {
    class { '::git':
      before => [ File[$sshpath], Exec['generate_key'] ],
    }
  }

  file { $sshpath:
    ensure => directory,
    mode   => '0600',
  }

  exec { 'generate_key':
    command => "ssh-keygen -t rsa -N '' -f '${sshpath}/id_rsa'",
    creates => "${sshpath}/id_rsa",
    require => File[$sshpath],
  }

  $machine_name = get_machine_name($::clientcert)

  exec { "git config --global user.name '${machine_name}'":
    unless  => 'git config --global user.name',
    require => Exec['generate_key'],
  }

  exec { "git config --global user.email ${machine_name}@puppetlabs.vm":
    unless  => 'git config --global user.email',
    require => Exec['generate_key'],
  }
}
