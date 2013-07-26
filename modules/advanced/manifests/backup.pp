# This is a helper class used with advanced::template
define advanced::backup(
  $path_to_copy = $title,
  $delete = true,
){
  if $delete {
    $cmd = 'mv -f'
  } else {
    $cmd = 'cp -a'
  }
  # Idempotence is accomlished via the .old file 
  exec { "${cmd} ${path_to_copy} ${path_to_copy}.old" :
    path    => '/bin:/usr/bin',
    creates => "${path_to_copy}.old",
  }

}
