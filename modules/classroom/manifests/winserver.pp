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
  
  # Download install for filezilla lab
  class { 'staging':
    path  => 'C:/shares/',
    require => Class['windows_ad'],
  }
  staging::file { 'FileZilla-setup.exe':
    source      => 'http://superb-dca3.dl.sourceforge.net/project/filezilla/FileZilla_Client/3.9.0.6/FileZilla_3.9.0.6_win32-setup.exe',
    require     => Class['staging'],
  }

  # Windows file share for filezilla lab
  fileshare { 'installer':
    ensure => present,
    path => 'C:\shares\classroom',
    require => Class['staging'],
  }
  acl { 'c:/shares/classroom/FileZilla-setup.exe':
    permissions => [
      { identity => 'Administrator', rights => ['full'] },
      { identity => 'Everyone', rights => ['read','execute'] }
    ],
    require => Staging::File['FileZilla-setup.exe'],
  }

  # Export AD server IP to be DNS server for agents
  @@classroom::dns_server { 'primary_ip':
    ip => $::ipaddress,
  } 
  # Add "CLASSROOM\admin" user to domain
    # Create OU for classroom
  windows_ad::organisationalunit{'STUDENTS':
    ensure       => present,
    path         => 'DC=CLASSROOM,DC=LOCAL',
    ouName       => 'STUDENTS',
    require      => Class['windows_ad'],
  }
  windows_ad::group{'WebsiteAdmins':
    ensure               => present,
    path                 => 'CN=Users,DC=CLASSROOM,DC=LOCAL',
    groupname            => 'WebsiteAdmins',
    groupscope           => 'Global',
    groupcategory        => 'Security',
    description          => 'Web Admins',
  }
  # Add "CLASSROOM\admin" user to domain
  windows_ad::user{'admin':
    ensure               => present,
    domainname           => 'CLASSROM.local',
    path                 => 'OU=STUDENTS,DC=CLASSROOM,DC=local',
    accountname          => 'admin',
    lastname             => 'Admin',
    firstname            => 'Classroom',
    passwordneverexpires => true,
    passwordlength       => 15,
    password             => 'M1Gr3atP@ssw0rd',
    emailaddress         => 'admin@CLASSROOM.local',
    require              => Windows_ad::Organisationalunit['STUDENTS'],
  }
}
