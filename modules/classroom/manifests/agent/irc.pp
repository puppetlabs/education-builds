class classroom::agent::irc {
  if $::osfamily == 'windows' {
    package { 'hexchat':
      ensure => present,
    }

    file { 'C:\Users\Administrator\AppData\Roaming\HexChat\hexchat.conf':
      ensure  => file,
      content => template("${module_name}/hexchat.conf.erb"),
      require => Package['hexchat'],
    }

    file { 'C:\Users\Administrator\AppData\Roaming\HexChat\servlist.conf':
      ensure  => file,
      content => template("${module_name}/servlist.conf.erb"),
      require => Package['hexchat'],
    }
  }
  else {
    # prepare a config file for the report handler
    $nick = "puppet"

    file { '/etc/puppetlabs/puppet/irc.yaml':
      ensure  => present,
      content => template('classroom/irc.yaml.erb'),
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
}
