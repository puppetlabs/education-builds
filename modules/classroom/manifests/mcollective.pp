# Backwards compatibility for PE 3.3 and older
class classroom::mcollective (
  $role = $classroom::params::role,
) inherits classroom::params {
  if $role == 'master' {
    # prepare mcollective certs & config for syncronization
    include classroom::mcollective::master
  }
  elsif $role == 'agent' {
    # synchronize mcollective certs & config to client node
    include classroom::mcollective::client
  }
}
