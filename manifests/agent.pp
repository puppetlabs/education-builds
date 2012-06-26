class edu_bootstrap::agent {

  require edu_bootstrap::repo

  package { 'fuse-sshfs':
    ensure => installed,
  }

  file { '/root/master_home':
    ensure => directory,
  }

}
