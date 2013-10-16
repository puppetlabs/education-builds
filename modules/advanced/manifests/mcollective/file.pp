define advanced::mcollective::file (
  $ensure   = file,
  $owner    = undef,
  $group    = undef,
  $mode     = undef,
  $cachedir = $advanced::mcollective::config::cachedir,
) {
  # This is the cached source name of the actual file
  $cachename = "${advanced::mcollective::config::cachedir}${name}"

  # Compiling directly into the catalog is loads safer than an unauthenticated
  # fileserver mountpoint. Still, this would probably never be done in production.
  file { $name:
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => file($cachename, '/dev/null'),
  }
}
