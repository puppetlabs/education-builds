class prosody {
  $certpath = '/etc/prosody/certs'
  $certsubj = "/C=US/ST=Oregon/L=Portland/O=Puppet Labs/CN=${::fqdn}"
  $certname = "${certpath}/${::fqdn}"

  package { 'prosody':
    ensure => installed,
  }

  file { '/etc/prosody/prosody.cfg.lua':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('prosody/prosody.cfg.lua.erb'),
    require => Package['prosody'],
  }

  exec { 'prosody certs':
    command => "openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj '${certsubj}' -keyout ${certname}.key  -out ${certname}.crt",
    path    => '/usr/bin',
    creates => "${certname}.crt",
    require => Package['prosody'],
  }

  service { 'prosody':
    ensure  => running,
    enable  => true,
    require => Exec['prosody certs'],
  }
}

