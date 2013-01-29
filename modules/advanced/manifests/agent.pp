class advanced::agent {
  class {'advanced::agent::hostname':} ->
  class {'advanced::agent::puppetdb':} ->
  class {'advanced::agent::peadmin':} ->
  class {'advanced::irc::client':}
}
