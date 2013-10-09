# Export out the host records for use with the students collectors
class advanced::proxy::hostname {
  Host <<| tag == 'classroom' |>>

  @@host { $::fqdn :
    ensure       => present,
    host_aliases => [$::hostname,'irc.puppetlabs.vm'],
    ip           => $::ipaddress,
    tag          => 'classroom'
  }
}
