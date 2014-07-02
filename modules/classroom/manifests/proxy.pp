class classroom::proxy {
  include '::haproxy'
  haproxy::listen { 'wordpress00':
    ipaddress => $::ipaddress,
    ports     => '80',
    options   => {
      'mode'  => 'http',
    },
  }

  haproxy::listen { 'stats':
    ipaddress => $::ipaddress,
    ports     => '9090',
    options   => {
      'mode'  => 'http',
      'stats' => ['uri /', 'auth puppet:puppet']
      },
  }

  Host <<| tag == 'classroom' |>>

  @@host { $::fqdn:
    ensure       => present,
    host_aliases => [$::hostname, 'irc.classroom.vm'],
    ip           => $::ipaddress,
    tag          => 'classroom'
  }
}
