# Configures haproxy server
class advanced::proxy::haproxy {
    class {'::haproxy':}
    haproxy::listen { 'puppet00':
      ipaddress => $::ipaddress,
      ports     => '8140',
      options   => {
        'mode'  => 'tcp',
      },
    }

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
}
