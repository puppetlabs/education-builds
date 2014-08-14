class classroom::master::balancermember {
  @@haproxy::balancermember { "puppet::${::fqdn}":
    listening_service => 'puppet00',
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    ports             => '8140',
    options           => 'check',
  }
}