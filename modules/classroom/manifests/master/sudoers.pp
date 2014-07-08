class classroom::master::sudoers {
  file { '/etc/sudoers.d/classroom':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/classroom/sudoers.classroom',
  }
}

