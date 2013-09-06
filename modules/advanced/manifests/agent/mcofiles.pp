# copy over files for mco to agents

class advanced::agent::mcofiles {

  $dir_ssl_files = '/etc/puppetlabs/puppet/ssl'
  $peadmin_certs_dir = '/var/lib/peadmin/.mcollective.d'
  $ssl_dirs = ['public_keys','private_keys','certs']
  $files_to_sync = [
    'public_keys/pe-internal-mcollective-servers.pem',
    'private_keys/pe-internal-mcollective-servers.pem',
    'certs/pe-internal-mcollective-servers.pem',
    'public_keys/pe-internal-peadmin-mcollective-client.pem',
    'public_keys/pe-internal-puppet-console-mcollective-client.pem',
  ]
  $peadmin_mco_certs = [
    'peadmin-private.pem',
    'peadmin-public.pem',
    'mcollective-public.pem',
    'peadmin-cacert.pem',
    'peadmin-cert.pem',
  ]
  
  # copy the credentials file too:
  file { "/etc/puppetlabs/mcollective/credentials" :
    source => 'puppet://classroom.puppetlabs.vm/ssl/credentials',
  }

  advanced::copy { $ssl_dirs :
    dir_path => $dir_ssl_files,
    is_dir   => true,
  }

  advanced::copy { $files_to_sync :
    dir_path => $dir_ssl_files,
    agent    => true,
  }
  
  advanced::copy { $peadmin_mco_certs :
    dir_path => $peadmin_certs_dir,
    agent    => true,
    owner    => 'peadmin',
  }

}
