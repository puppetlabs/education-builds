class fundamentals::exercise::8::1 inherits fundamentals::exercise::7::1 {
  $exercise_major   = '8'
  $exercise_minor   = '1'
  $exercise_version = "${exercise_major}.${exercise_minor}" 

  $exercise_module  = 'apache'

  # Create your index.html file
  file { $exercise_module :
    ensure => directory,
    path   => "/root/master_home/modules/${exercise_module}",
    tag    => $exercise_version,
  }
  file { "${exercise_module}/files":
    ensure => directory,
    path   => "/root/master_home/modules/${exercise_module}/files",
    tag    => $exercise_version,
  }
  file { "${exercise_module}/files/index.html":
    ensure  => file,
    path    => "/root/master_home/modules/${exercise_module}/files/index.html",
    content => template("${module_name}/exercise/${exercise_major}/${exercise_minor}/${exercise_module}/files/index.html.erb"),
    tag     => $exercise_version,
  }

  # Create your init.pp file
  file { "${exercise_module}/manifests":
    ensure => directory,
    path   => "/root/master_home/modules/${exercise_module}/manifests",
    tag    => $exercise_version,
  }
  file { "${exercise_module}/manifests/init.pp":
    ensure  => file,
    path    => "/root/master_home/modules/${exercise_module}/manifests/init.pp",
    content => template("${module_name}/exercise/${exercise_major}/${exercise_minor}/${exercise_module}/manifests/init.pp.erb"),
    tag     => $exercise_version,
  }

  # Create your smoke test
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
