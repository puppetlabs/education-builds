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
