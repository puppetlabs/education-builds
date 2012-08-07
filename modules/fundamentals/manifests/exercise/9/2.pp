class fundamentals::exercise::9::2 inherits fundamentals::exercise::9::1 {
  $exercise_major   = '9'
  $exercise_minor   = '2'
  $exercise_version = "${exercise_major}.${exercise_minor}"

  $exercise_module  = 'apache'
  File ["${exercise_module}/manifests/init.pp"] {
    content => template("${module_name}/exercise/${exercise_major}/${exercise_minor}/${exercise_module}/manifests/init.pp.erb"),
    tag     => $exercise_version,
  }
  File ["${exercise_module}/files/index.html"] {
    content => template("${module_name}/exercise/${exercise_major}/${exercise_minor}/${exercise_module}/files/index.html.erb"),
    tag     => $exercise_version,
  }
}
