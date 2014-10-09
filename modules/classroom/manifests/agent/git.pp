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

  if $::osfamily == 'windows' {
    file { 'c:/git_install.exe':
      ensure => present,
      source => 'puppet:///modules/classroom/Git-1.9.4-preview20140929.exe',
      before => Exec['install git'],
    }
    exec { 'install git':
      command => 'c:/git_install.exe /VERYSILENT',
      creates => 'C:\Program Files (x86)\Git',
      path    => $::path,
      before  => Exec['generate_key'],
      notify  => Exec['add git to path'],
    }
    exec { 'add git to path': 
      command     => 'setx path "%path%;C:\Program Files (x86)\Git\bin"',
      path        => $::path,
      refreshonly => true,
    }
  }
  else {
    class { '::git':
      before => Exec['generate_key'],
    }
  }

  file { $sshpath:
    ensure => directory,
    mode   => '0600',
  }

  exec { 'generate_key':
    command => "ssh-keygen -t rsa -N '' -f '${sshpath}/id_rsa'",
    creates => "${sshpath}/id_rsa",
  }

  exec { "git config --global user.name '${::hostname}'":
    unless  => 'git config --global user.name',
    require => Exec['generate_key'],
  }

  exec { "git config --global user.email ${::hostname}@puppetlabs.vm":
    unless  => 'git config --global user.email',
    require => Exec['generate_key'],
  }
}
