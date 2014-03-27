class learning {
  File {
    owner => root,
    group => root,
    mode  => 644,
  }

  file { '/root/learning.answers':
    ensure => file,
    source => 'puppet:///modules/learning/learning.answers',
  }

  # Print this info when we log in, too.
  file {'/etc/motd':
    ensure => file,
    owner  => root,
    mode   => 0644,
    source => 'puppet:///modules/learning/etc/motd',
  }

  package { 'tmux':
    ensure => present,
  }

}
