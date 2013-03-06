# This class configures our irc server
class advanced::irc::server {
  package {'pe-rubygem-json':
    ensure => present,
  }

  # This is our report processor
  class {'irc':
    require => Package['pe-rubygem-json'],
  }
  include charybdis::default

  Charybdis::General <| title == 'default_ident_timeout' |> {
    value => '0',
  }
  #/oper classroom
  charybdis::operator { 'classroom':
    users    => ['*@*'],
    privset  => 'admin',
    password => 'puppet',
    snomask  => '+CZbcdfkrsuxy',
    flags    => [
      '~encrypted',
      '~need_ssl',
    ],
    umodes   => [
      'locops',
      'servnotice',
      'operwall',
      'wallop',
    ],
  }
  # This is our irssi client configuration
  include advanced::irc::client
}
