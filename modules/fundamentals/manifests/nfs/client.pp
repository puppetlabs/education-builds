class fundamentals::nfs::client {
  file { '/root/master_home':
    ensure => directory,
  }
  mount { "/root/master_home":
    device  => "${::servername}:/home/${::hostname}",
    fstype  => "nfs",
    ensure  => "mounted",
    options => "rw",
    atboot  => true,
    require => File['/root/master_home'],
 }
}
