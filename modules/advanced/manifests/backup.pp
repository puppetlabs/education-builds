# This is a helper class used with advanced::template
define advanced::backup(
  $path_to_copy = $title,
){

  # Idempotence is accomlished via the .old file 
  exec { "cp -a ${path_to_copy} ${path_to_copy}.old" :
    path    => '/bin:/usr/bin',
    creates => "${path_to_copy}.old",
  }

}
