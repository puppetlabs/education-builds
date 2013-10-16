class advanced::irc::client {
  # prepare a config file for the report handler
  $nick = "puppetmaster-${::hostname}"

  file { '/etc/puppetlabs/puppet/irc.yaml':
    ensure  => present,
    content => template('advanced/irc.yaml.erb'),
  }

  # gems used by the irc report handler.
  package { 'carrier-pigeon':
    ensure   => present,
    provider => pe_gem,
  }

  # configure the client connection to the irc server
  package { 'irssi':
    ensure => present,
  }
  file { "${::root_home}/.irssi":
    ensure  => directory,
    require => Package['irssi'],
  }
  file { "${::root_home}/.irssi/config":
    ensure  => present,
    content => template("${module_name}/irssi.conf.erb"),
    require => Package['irssi'],
  }
}
