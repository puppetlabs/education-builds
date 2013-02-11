# This is the class applied to all systems
class advanced {
  if    $::hostname == 'classroom' {
    include advanced::classroom
  }
  elsif $::hostname == 'proxy' {
    include advanced::proxy
  }
  else {
    include advanced::agent
  }
}
