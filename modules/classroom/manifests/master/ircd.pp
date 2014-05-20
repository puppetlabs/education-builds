# Simple and inflexible IRCd setup for the classroom
class classroom::master::ircd {
  package { 'ngircd':
    ensure => present,
  }

  file { '/etc/ngircd.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/ngircd.conf.erb"),
  }

  service { 'ngircd':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/ngircd.conf'],
  }
}
