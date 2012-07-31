class fundamentals::exercise::10::1 inherits fundamentals::exercise::9::2 {
  $exercise_version = '10.1'
  exec { 'facter ipaddress':
    command   => 'facter ipaddress',
    logoutput => true,
    path      => '/usr/local/bin'
  }
  exec { 'facter operatingsystem':
    command   => 'facter operatingsystem',
    logoutput => true,
    path      => '/usr/local/bin'
  }
  exec { 'facter':
    command   => 'facter',
    logoutput => true,
    path      => '/usr/local/bin'
  }
}
