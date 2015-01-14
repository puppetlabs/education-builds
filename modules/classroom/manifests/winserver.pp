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
    unless => 'if (net user Administrator |select-string -pattern "Password required.*no"){exit 1}',
    provider => powershell,
  }

  # Increase the number of machines that a single user can join to the domain
  exec { 'SetMachineQuota':
    command   => 'get-addomain |set-addomain -Replace @{\'ms-DS-MachineAccountQuota\'=\'99\'}',
    unless    => 'if ((get-addomain | get-adobject -prop \'ms-DS-MachineAccountQuota\' | select -exp \'ms-DS-MachineAccountQuota\') -lt 99) {exit 1}',
    provider  => powershell,
    require   => Class['windows_ad'],
  }

  # Export AD server IP to be DNS server for agents
  @@classroom::dns_server { 'primary_ip':
    ip => $::ipaddress,
  } 
}
