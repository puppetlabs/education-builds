class extending::capstone::requirements {
  # intentionally allowing these to float. Because I'm lazy.
  include apache
  include apache::mod::php
  include mysql::server

  package { 'php-mysql':
    ensure => present,
    require => Class['mysql::server'],
  }

  $staging = "${settings::vardir}/staging"
  file { $staging:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 700,
  }

  file { "${staging}/cache_mysql_root_pw.sh":
    ensure => file,
    owner  => root,
    group  => root,
    mode   => 700,
    source => 'puppet:///modules/extending/capstone/cache_mysql_root_pw.sh',
  }

  exec { 'cache mysql root password':
    command => "${staging}/cache_root_mysql_pw.sh",
    require => File["${staging}/cache_mysql_root_pw.sh"],
    creates => '/root/.my.cnf',
  }
}