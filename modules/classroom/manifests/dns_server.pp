# Set a DNS server on the windows agents
define classroom::dns_server (
  $ip = '8.8.8.8',
) {
    # Only run on windows
    if $::osfamily  == 'windows' {
      exec { 'set_dns':
        command   => "set-DnsClientServerAddress -interfacealias Ethernet0 -serveraddresses $ip",
        unless    => "if ((Get-DnsClientServerAddress -addressfamily ipv4 -interfacealias Ethernet0).serveraddresses -ceq '$ip')",
        provider  => powershell,
      }
    }
}
