# Main class applied to classroom
class advanced::classroom {
  include kickstand
  include advanced::irc::client
  include advanced::classroom::puppetdb
  include advanced::mcollective::master

  # console fixes for Safari
  include advanced::classroom::console
}
