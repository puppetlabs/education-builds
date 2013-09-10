define advanced::copy(
  $to_copy = $name,
  $dir_path,
  $is_dir = false,
  $agent = false,
  $source_dir = $::settings::ssldir,
  $owner = 'pe-puppet',
){
  $filesource = $agent ? {
    true    => 'puppet://classroom.puppetlabs.vm/ssl',
    false   => $source_dir,
    default => undef,
  }
  if $is_dir {
      file { "${dir_path}/${to_copy}" :
        ensure => directory,
      }
    } else {
      file { "${dir_path}/${to_copy}" :
        ensure => file,
        source => "${filesource}/${to_copy}",
        owner  => $owner,
      }
    }
}
