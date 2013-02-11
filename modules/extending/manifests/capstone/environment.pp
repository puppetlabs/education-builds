class extending::capstone::environment {
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
    command => "${staging}/cache_mysql_root_pw.sh",
    require => File["${staging}/cache_mysql_root_pw.sh"],
    creates => '/root/.my.cnf',
  }
}