class learning {
  File {
    owner => root,
    group => root,
    mode  => 644,
  }

  file { '/root/learning.answers':
    ensure => file,
    source => 'puppet:///modules/learning/learning.answers',
  }

  # Actually not planning to disable these services, on further consideration.
  #Service {
  #  require   => Exec['install-pe'],
  #  hasstatus => true,
  #  ensure    => stopped,
  #  enable    => false,
  #}
  #service { 'pe-puppet': }
  #service { 'pe-httpd': }
  #service { 'pe-activemq': }

  # /etc/puppet/ssl is confusing to have around. Sloppy. Kill.
  file {'/etc/puppet':
    ensure  => absent,
    recurse => true,
    force   => true,
  }
}
