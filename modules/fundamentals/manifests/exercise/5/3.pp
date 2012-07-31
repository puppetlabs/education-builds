class fundamentals::exercise::5::3 inherits fundamentals::exercise::5::2 {
  $exercise_major   = '5'
  $exercise_minor   = '3'
  $exercise_version = "${exercise_major}.${exercise_minor}"

  $exercise_module  = 'users'

  File["${exercise_module}/tests/init.pp"] {
    content => template("${module_name}/exercise/${exercise_major}/${exercise_minor}/${exercise_module}/tests/init.pp.erb"),
    tag     => $exercise_version,
  }
  File["${exercise_module}/manifests/init.pp"] {
    content => template("${module_name}/exercise/${exercise_major}/${exercise_minor}/${exercise_module}/manifests/init.pp.erb"),
    tag     => $exercise_version,
  }
}
