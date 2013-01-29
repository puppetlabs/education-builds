# This is a helper class used with advanced::template
define advanced::backup(
  $path_to_move = $title,
){

  # Idempotence is accomlished via the .old file extance
  exec { "mv -f ${path_to_move} ${path_to_move}.old" :
    path    => '/bin:/usr/bin',
    creates => "${path_to_move}.old",
  }

}
