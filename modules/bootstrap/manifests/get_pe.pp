# -------
# Fetch PE and unzip full installer
# Stage agent installer.
# -------

define bootstrap::get_pe(
  $staging_dir = '/usr/src/installer',
  $version   = undef
) {
  $pe_destination = "/root/"
  $pe_file = "puppet-enterprise-${ver}-el-6-i386.tar.gz"
  $agent_file = "puppet-enterprise-${ver}-agent-el-6-i386.tar.gz"
  $url      = "https://s3.amazonaws.com/pe-builds/released/${ver}/${filename}"
  
  class { 'staging':
    path  => $staging_dir,
    owner => 'puppet',
    group => 'puppet',
  }

  if $version {
    $ver = $version
  } else {
    $ver = 'latest'
  }


  staging::file{ $agent_file:
    source => $url,
  }

  staging::deploy{ $pe_file:
    source => $url,
    target => $pe_destination,
  }
}
