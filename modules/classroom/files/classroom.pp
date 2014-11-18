# Cut down on agent output noise.
Package { allow_virtual => true }

# dirty hack to allow student masters to download the agent tarball in Architect
Pe_staging::File { curl_option => '-k' }

# top level tweaks for windows
if $::osfamily == windows {
  # default package provider
  Package {
    provider => chocolatey,
    require  => Exec['install-chocolatey'],
  }

  File {
    source_permissions => ignore,
  }
}
