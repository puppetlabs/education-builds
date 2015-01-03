class classroom::winserver {

  class { 'windows_ad' :
    install                => present,
    installmanagementtools => true,
    restart                => true,
    installflag            => true,
    configure              => present,
    configureflag          => true,
    domaintype             => 'Forest',
    domain                 => 'forest',
    domainname             => 'CLASSROOM.local',
    netbiosdomainname      => 'CLASSROOM',
    domainlevel            => '6',
    forestlevel            => '6',
    installtype            => 'domain',
    installdns             => 'yes',
    dsrmpassword           => 'Puppetlabs1',
  }

}
