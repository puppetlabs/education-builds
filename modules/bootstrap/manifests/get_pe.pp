# -------
# Fetch PE and unzip full installer
# Stage agent installer.
# -------

class bootstrap::get_pe(
  $version   = 'latest'
) {
  $pe_destination = "/root/"
  $architecture   = 'i386'
  $pe_file        = "puppet-enterprise-${version}-el-6-${architecture}.tar.gz"
  $agent_file     = "puppet-enterprise-${version}-el-6-${architecture}-agent.tar.gz"
  $url            = "https://s3.amazonaws.com/pe-builds/released/${version}"

  staging::file{ $agent_file:
    source => "${url}/${agent_file}",
  }

  staging::file{ $pe_file:
    source => "${url}/${pe_file}",
    target => $pe_destination,
  }
}
