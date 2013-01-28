class extending::instructor::reports {
  include prosody

  prosody::user { 'instructor':
    ensure   => present,
    password => 'puppet',
    require  => Class['prosody'],
  }

  if $::students {
    $list = split($::students, ',')
    prosody::user { $list:
      ensure   => present,
      password => 'puppet',
      require  => Class['prosody'],
    }
  }
  else {
    notice("Don't forget to set the students fact!")
  }
}
