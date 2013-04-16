# This class is applied to the student machines
class advanced::agent {
  class {'advanced::agent::hostname':} ->
  class {'advanced::agent::puppetdb':} ->
  class {'advanced::agent::peadmin':} ->
  class {'advanced::irc::client':}
  
  # If this agent has PE < 2.7.1, we need to copy over some ssl certs 
  # and the mcollective credentials file
  if versioncmp($::pe_version, '2.7.1') < 0 {
    include advanced::agent::mcofiles
  }
}
