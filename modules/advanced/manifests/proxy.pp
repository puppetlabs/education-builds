class advanced::proxy {
  include advanced::irc::server

  class {'advanced::proxy::hostname':}
  -> class {'advanced::proxy::haproxy':}
}
