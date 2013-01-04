# -------
# Fetch forge module as tar.gz.
# -------

define bootstrap::forge(
  $cache_dir = '/usr/src/forge',
  $version   = undef
) {

  if $version {
    $ver = $version
  } else {
    # Hideous hack to ask puppet/face for latest version, assumes only one result, and takes first version.
    $ver = inline_template("<% require 'puppet/face'-%><%=
begin
  Puppet::Face[:module,'1.0.0'].search('${name}').first['releases'].first['version']
rescue
  nil
end -%>")
    if !$ver { fail("Unable to determine ${name} module version.") }
  }

  $mod = split($name, '-')
  $author = $mod[0]
  $module = $mod[1]
  $filename = "${author}-${module}-${ver}.tar.gz"
  $url      = "http://forge.puppetlabs.com/${author}/${module}/${ver}.tar.gz"

  exec { "curl ${name}":
    command => "curl -o ${cache_dir}/${filename} $url",
    path    => '/usr/local/bin:/usr/bin:/bin',
    creates => "${cache_dir}/${filename}",
    require => File[$cache_dir],
  }

}
