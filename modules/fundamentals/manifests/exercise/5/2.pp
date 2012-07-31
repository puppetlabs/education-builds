class fundamentals::exercise::5::2 inherits fundamentals::exercise::5::1 {
  $exercise_major   = '5'
  $exercise_minor   = '2'
  $exercise_version = "${exercise_major}.${exercise_minor}"

  $exercise_module  = 'users'

  file { "${exercise_module}/tests":
    ensure => directory,
    path   => "/root/master_home/modules/${exercise_module}/tests",
    tag    => $exercise_version,
  }
  file { "${exercise_module}/tests/init.pp":
    ensure  => file,
    path    => "/root/master_home/modules/${exercise_module}/tests/init.pp",
    content => template("${module_name}/exercise/${exercise_major}/${exercise_minor}/${exercise_module}/tests/init.pp.erb"),
    tag     => $exercise_version,
  }
}
