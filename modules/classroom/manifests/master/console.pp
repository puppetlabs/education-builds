class classroom::master::console {
    
  # Fixes to make the console accessible by the IP address of the master
  # Required for PE 3.0.0
  # Enables the PE console to be accessed without reliable DNS
  # See: https://jira.puppetlabs.com/browse/PE-870

  file_line { 'console_auth_url':
    ensure => present,
    path   => '/etc/puppetlabs/console-auth/config.yml',
    match  => '\s*cas_url:',
    line   => "  cas_url: https://${::ipaddress}:443/cas",
  }

  file_line { 'console_auth_hostname':
    ensure => present,
    path   => '/etc/puppetlabs/console-auth/config.yml',
    match  => '\s*console_hostname:',
    line   => "  console_hostname: ${::ipaddress}",
  }

  file_line { 'rubycas_server_console_base_url':
    ensure => present,
    path   => '/etc/puppetlabs/rubycas-server/config.yml',
    match  => '^console_base_url:',
    line   => "console_base_url: https://${::ipaddress}:443/",
    notify => Service['pe-httpd'],
  }

}
