# -------
# Fetch forge module as tar.gz.
# -------

define bootstrap::forge(
  $cache_dir = '/usr/src/forge',
  $version   = undef
) {
  $mod = split($name, '[-/]')
  $author = $mod[0]
  $module = $mod[1]
  
  if $version {
    $ver = $version
  } else {
    $ver = latest_module_version($author, $module)
    if !$ver { fail("Unable to determine ${author}-${name}'s version.") }
  }

  $filename = "${author}-${module}-${ver}.tar.gz"
  $url      = "https://forgeapi.puppetlabs.com/v3/files/${filename}"

  exec { "curl ${name}":
    command => "curl -o ${cache_dir}/${filename} $url",
    path    => '/usr/local/bin:/usr/bin:/bin',
    creates => "${cache_dir}/${filename}",
    require => File[$cache_dir],
  }

}
