class advanced {
  if versioncmp($::pe_version, '3.0.0') < 0 {
    if $::hostname == 'classroom' {
      fail ("The classroom master requires PE >= 3.0.")
    }
    else {
      fail ("The version of Puppet Enterprise installed is ${::pe_version}. This course is designed for PE >= 3.0 and parts of the class, including Live Management and Scaling, will not behave as expected. Please request a current VM from your instructor.")
    }
  }

  case $::hostname {
    'classroom': { include advanced::classroom }
    'proxy'    : { include advanced::proxy     }
    default    : { include advanced::agent     }
  }
}
