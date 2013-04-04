# copy over files for mco to agents

class advanced::agent::mcofiles {

  $dir_ssl_files = '/etc/puppetlabs/puppet/ssl'
  $ssl_dirs = ['public_keys','private_keys','certs']
  $files_to_sync = [
    'public_keys/pe-internal-mcollective-servers.pem',
    'private_keys/pe-internal-mcollective-servers.pem',
    'certs/pe-internal-mcollective-servers.pem',
    'public_keys/pe-internal-peadmin-mcollective-client.pem',
    'public_keys/pe-internal-puppet-console-mcollective-client.pem',
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
    sync     => true,
  }
}
