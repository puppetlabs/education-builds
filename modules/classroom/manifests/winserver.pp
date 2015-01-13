class classroom::winserver inherits classroom::params {

  class { 'windows_ad' :
    install                => present,
    installmanagementtools => true,
    restart                => true,
    installflag            => true,
    configure              => present,
    configureflag          => true,
    domaintype             => 'Forest',
    domain                 => 'forest',
    domainname             => $classroom::params::ad_domainname, 
    netbiosdomainname      => $classroom::params::ad_netbiosdomainname,
    domainlevel            => '6',
    forestlevel            => '6',
    installtype            => 'domain',
    installdns             => 'no',
    dsrmpassword           => $classroom::params::ad_dsrmpassword,     
    require                => Exec['RequirePassword'],
  }
  # Local administrator is required to have a password before AD will install
  exec { 'RequirePassword':
    command => 'net user Administrator /passwordreq:yes',
    unless => 'if (net user Administrator |select-string -pattern "Password required.*yes)',
    provider => powershell,
  }

  # Export AD server IP to be DNS server for agents
  @@classroom::dns_server { 'title':
    ip => $::ipaddress,
  } 
}
