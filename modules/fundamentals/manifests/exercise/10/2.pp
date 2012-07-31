class fundamentals::exercise::10::2 inherits fundamentals::exercise::10::1 {
  $exercise_major   = '10'
  $exercise_minor   = '2'
  $exercise_version = "${exercise_major}.${exercise_minor}"

  $exercise_module  = 'apache'
  file { "${exercise_module}/templates":
    ensure => directory,
    path => "/root/master_home/modules/${exercise_module}/templates",
    tag    => $exercise_version,
  }
  file { "${exercise_module}/templates/index.html.erb":
    ensure  => file,
    path    => "/root/master_home/modules/${exercise_module}/templates/index.html.erb",
    source => "puppet:///modules/${module_name}/exercise/${exercise_major}/${exercise_minor}/${exercise_module}/templates/index.html.erb",
    tag     => $exercise_version,
  }

  File ["${exercise_module}/manifests/init.pp"] {
    content => template("${module_name}/exercise/${exercise_major}/${exercise_minor}/${exercise_module}/manifests/init.pp.erb"),
    tag     => $exercise_version,
  }
}
