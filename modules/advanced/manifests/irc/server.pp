class advanced::irc::server {
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
      '~need_ident',
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
