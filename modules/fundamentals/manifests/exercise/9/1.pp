class fundamentals::exercise::9::1 inherits fundamentals::exercise::8::1 {
  $exercise_major   = '9'
  $exercise_minor   = '1'
  $exercise_version = "${exercise_major}.${exercise_version}"

  $exercise_module  = 'apache'
  File ["${exercise_module}/manifests/init.pp"] {
    content => template("${module_name}/exercise/${exercise_major}/${exercise_minor}/${exercise_module}/manifests/init.pp.erb"),
  }
}
