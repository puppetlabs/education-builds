class classroom::agent::git {
  case $::osfamily {
    'windows' : {
      $path = 'C:\Program Files (x86)\Git\bin'
      $sshpath = 'C:/Users/Administrator/.ssh'
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
      before  => Exec['generate key'],
    }
  }
  else {
    class { '::git':
      before => Exec['generate key'],
    }
  }

  exec { 'generate_key':
    command => "ssh-keygen -t rsa -N '' -f ${sshpath}",
    creates => "${sshpath}/id_rsa",
  }

  exec { "git config --global user.name '${::hostname}'":
    unless  => 'git config --global user.name',
    require => Exec['generate key'],
  }

  exec { "git config --global user.email ${::hostname}@puppetlabs.vm":
    unless  => 'git config --global user.email',
    require => Exec['generate key'],
  }
}
