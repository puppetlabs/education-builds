class advanced::irc::server {
  # This is our report processor .... should this be on the... master?
  include irc
  include charybdis::default

  # TODO: no more evilness!
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
