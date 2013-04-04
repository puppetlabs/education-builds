# This class is applied to the student machines
class advanced::agent {
  class {'advanced::agent::hostname':} ->
  class {'advanced::agent::puppetdb':} ->
  class {'advanced::agent::peadmin':} ->
  class {'advanced::irc::client':}
  $advanced_pe_version = adv_pe_ver()
  
  # If this agent has PE < 2.7.2, we need to copy over some ssl certs 
  # and the mcollective credentials file
  if versioncmp($advanced_pe_version, '2.7.2') < 0 {
    include advanced::agent::mcofiles
  }
}
