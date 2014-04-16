File {
  owner => 'root',
  group => 'root',
  mode  => '0755',
}

package { 'httpd':
  ensure => present,
}

service { 'httpd':
  ensure  => 'running',
  require => Package['httpd'],
}

file { '/var/www':
  ensure => directory,
}

file { '/var/www/html':
  ensure  => directory,
  source  => '/usr/src/puppetlabs-training-bootstrap/modules/learning/files/guide',
  recurse => true,
  notify  => Service['httpd'],
}
