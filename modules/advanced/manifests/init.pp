# This is the class applied to all systems
class advanced {
  if    $::hostname == 'classroom' {
    if versioncmp( $::pe_version, 2.7.1) < 0 {
      fail ("The version of PE installed on ${::fqdn} is ${::pe_version}. You need PE > 2.7.1 installed on ${::fqdn}!")
    } else {
      include advanced::classroom
    }
  }
  elsif $::hostname == 'proxy' {
    include advanced::proxy
  }
  else {
    include advanced::agent
  }
}
