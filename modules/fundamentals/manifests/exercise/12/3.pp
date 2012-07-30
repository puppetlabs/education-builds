class fundamentals::exercise::12::3 inherits fundamentals::exercise::12::2 {
  $exercise_major   = '12'
  $exercise_minor   = '3'
  $exercise_version = "${exercise_major}.${exercise_minor}" 

  $exercise_module  = 'conditionals'
  File ["${exercise_module}/manifests/init.pp"] {
    content => template("${module_name}/exercise/${exercise_major}/${exercise_minor}/${exercise_module}/manifests/init.pp.erb"),
    tag     => $exercise_version,
  }
}

