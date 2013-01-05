include apache
include apache::mod::php
include mysql::server

package { 'php-mysql':
  ensure => present,
}

include drupal

