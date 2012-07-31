class fundamentals::exercise::6::1 inherits fundamentals::exercise::5::3 {
  $exercise_version = '6.1'
  exec { 'userdel':
    command => "userdel ${hostname}",
    path    => '/usr/sbin:/usr/bin',
    onlyif  => "id ${hostname}",
    tag     => $exercise_version,
  }
}
