class classroom::agent::hosts {
  @@host { $::fqdn:
    ensure       => 'present',
    host_aliases => [$::hostname],
    ip           => $::ipaddress,
    tag          => ['classroom','master'],
  }

  # Host <<| tag == 'classroom' |>>
}
