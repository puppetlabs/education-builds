class fundamentals::exercise::11::1 inherits fundamentals::exercise::10::2 {
  $exercise_major   = '11'
  $exercise_minor   = '1'
  $exercise_version = "${exercise_major}.${exercise_minor}"

  $exercise_module  = 'apache'
  file { "${exercise_module}/templates/vhost.conf.erb":
    ensure  => file,
    path    => "/root/master_home/modules/${exercise_module}/templates/vhost.conf.erb",
    source  => "puppet:///modules/${module_name}/exercise/${exercise_major}/${exercise_minor}/${exercise_module}/templates/vhost.conf.erb",
    tag     => $exercise_version,
  }
  file { "${exercise_module}/manifests/vhost.pp":
    ensure  => file,
    path    => "/root/master_home/modules/${exercise_module}/manifests/vhost.pp",
    content => template("${module_name}/exercise/${exercise_major}/${exercise_minor}/${exercise_module}/manifests/vhost.pp.erb"),
    tag     => $exercise_version,
  }
  File ["${exercise_module}/manifests/init.pp"] {
    content => template("${module_name}/exercise/${exercise_major}/${exercise_minor}/${exercise_module}/manifests/init.pp.erb"),
    tag     => $exercise_version,
  }
}
