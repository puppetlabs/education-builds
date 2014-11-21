define bootstrap::gem(
  $cache_dir = '/var/cache/rubygems/gems',
  $version   = undef
) {

  if $version {
    $gem     = "${name} -v ${version}"
    $pattern = "${name}-${version}*"
  }
  else {
    $gem     = $name
    $pattern = "${name}-[0-9]*\\.[0-9]*\\.[0-9]*"
  }

  # use unless instead of creates because without a version number, we need a regex
  exec { "gem fetch ${gem}":
    path    => '/opt/puppet/bin:/usr/local/bin:/usr/bin:/bin',
    cwd     => $cache_dir,
    unless  => "find ${cache_dir} -type f -name '${pattern}.gem' | grep '.*'",
    require => File[$cache_dir],
    notify  => Exec['rebuild_gem_cache'],
  }
}
