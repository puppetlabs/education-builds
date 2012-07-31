class fundamentals::exercise::12::4 inherits fundamentals::exercise::12::3 {
  $exercise_major   = '12'
  $exercise_minor   = '4'
  $exercise_version = "${exercise_major}.${exercise_minor}" 

  $exercise_module  = 'apache'
  File ["${exercise_module}/manifests/init.pp"] {
    content => template("${module_name}/exercise/${exercise_major}/${exercise_minor}/${exercise_module}/manifests/init.pp.erb"),
    tag     => $exercise_version,
  }
  File ["${exercise_module}/manifests/vhost.pp"] {
    content => template("${module_name}/exercise/${exercise_major}/${exercise_minor}/${exercise_module}/manifests/vhost.pp.erb"),
    tag     => $exercise_version,
  }
}

