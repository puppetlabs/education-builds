define classroom::mcollective::cache (
  $ensure   = file,
  $cachedir = $classroom::mcollective::config::cachedir,
) {
  # This is the final name of the actual cached file
  $filename = "${classroom::mcollective::config::cachedir}/${name}"

  file { $filename:
    ensure => $ensure,
    owner  => $classroom::mcollective::config::master_user,
    group  => $classroom::mcollective::config::master_group,
    mode   => '0600',
    source => $name,
  }
}
