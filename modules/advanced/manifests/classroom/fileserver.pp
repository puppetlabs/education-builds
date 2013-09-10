class advanced::classroom::fileserver {

  File {
    ensure => file,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0440',
  }

  $ssl_mco_files = "${::settings::confdir}/ssl_mco_files"
  $ssldirs = ['public_keys','private_keys','certs']
  $mcofiles = [
    'public_keys/pe-internal-mcollective-servers.pem',
    'private_keys/pe-internal-mcollective-servers.pem',
    'certs/pe-internal-mcollective-servers.pem',
    'public_keys/pe-internal-peadmin-mcollective-client.pem',
    'public_keys/pe-internal-puppet-console-mcollective-client.pem',
  ]
  
  $peadmin_cert_files = [
    'peadmin-private.pem',
    'peadmin-public.pem',
    'mcollective-public.pem',
    'peadmin-cacert.pem',
    'peadmin-cert.pem',
  ]

  # copy the credentials file too:
  file { "${ssl_mco_files}/credentials" :
    source => '/etc/puppetlabs/mcollective/credentials',
  }

  # This directory is a fileserver mountpoint that has the files
  file { $ssl_mco_files :
    ensure => directory,
  }

  # Manage fileserver.conf 
  file { "${::settings::confdir}/fileserver.conf":
    source => 'puppet:///modules/advanced/fileserver.conf',
  }

  advanced::copy { $ssldirs :
    dir_path => $ssl_mco_files,
    is_dir   => true,
  }

  # Copy over the required certs and credential file to the mountpoint
  advanced::copy { $mcofiles :
    dir_path => $ssl_mco_files,
  }

  advanced::copy { $peadmin_cert_files :
    dir_path   => $ssl_mco_files,
    source_dir => '/var/lib/peadmin/.mcollective.d',
  }
}
