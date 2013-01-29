# This class configures the irssi client settings
class advanced::irc::client {
  package { 'irssi':
    ensure => present,
  }
  file { "${::root_home}/.irssi":
    ensure  => directory,
    require => Package['irssi'],
  }
  file { "${::root_home}/.irssi/config":
    ensure  => present,
    content => template("${module_name}/.irssi/config/irssi.conf.erb"),
    require => Package['irssi'],
  }
}
