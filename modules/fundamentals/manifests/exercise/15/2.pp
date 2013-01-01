class fundamentals::exercise::15::2 inherits fundamentals::exercise::15::1 {
  $exercise_major   = '15'
  $exercise_minor   = '2'
  $exercise_version = "${exercise_major}.${exercise_version}"

  $exercise_module  = 'apache'

  File ["${exercise_module}/manifests/init.pp"] {
    content => template("${module_name}/exercise/${exercise_major}/${exercise_minor}/${exercise_module}/manifests/init.pp.erb"),
    tag     => $exercise_version,
  }

}

