class advanced::proxy::hostname {
  Host <| tag == 'classroom' |>
  @@host { $::fqdn :
    ensure       => present,
    host_aliases => [$::hostname,'irc.puppetlabs.vm'],
    ip           => $::ipaddress,
    target       => '/etc/hosts',
    tag          => 'classroom'
  }
}
