define advanced::mcollective::cache (
  $ensure   = file,
  $cachedir = $advanced::mcollective::config::cachedir,
) {
  # This is the final name of the actual cached file
  $filename = "${advanced::mcollective::config::cachedir}/${name}"

  file { $filename:
    ensure => $ensure,
    owner  => $advanced::mcollective::config::master_user,
    group  => $advanced::mcollective::config::master_group,
    mode   => '0600',
    source => $name,
  }
}
