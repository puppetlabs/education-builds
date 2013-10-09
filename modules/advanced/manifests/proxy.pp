class advanced::proxy {
  include advanced::irc::server
  include advanced::proxy::haproxy
  include advanced::proxy::hostname
}
