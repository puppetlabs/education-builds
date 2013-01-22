class extending::capstone::requirements (
  $database       = 'drupal',
  $dbuser         = 'drupal',
  $dbpassword     = 'drupal',
  $dbhost         = 'localhost',
) {
  include apache
  include apache::mod::php
  include mysql::server

  package { 'php-mysql':
    ensure => present,
  }

  apache::vhost { $::fqdn:
    ensure     => present,
    vhost_name => '*',
    port       => '80',
    ssl        => false,
    override   => 'all',
    docroot    => '/usr/share/drupal7',
  }

  mysql::db { $database:
    ensure   => present,
    user     => $dbuser,
    password => $dbpassword,
    host     => $dbhost,
    grant    => ['all'],
  }
}
