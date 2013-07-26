# Main class applied to classroom
class advanced::classroom {
  package { 'sinatra-base':
    ensure   => present,
    provider => pe_gem,
    before   => Class['kickstand']
  }
  class { 'kickstand': }
  include advanced::classroom::fileserver
  # These are the files that we manage with this class
  $files_to_backup = [
    '/etc/puppetlabs/console-auth/config.yml',
    '/etc/puppetlabs/rubycas-server/config.yml',
    '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
  ]
  
  $files_to_replace = [
    '/etc/puppetlabs/puppet/auth.conf',
    '/etc/puppetlabs/puppet/manifests/site.pp',
  ]

  class {'advanced::classroom::puppetdb':} 
  class {'advanced::mcollective':} 
  class {'advanced::irc::client':}

  # TDB: Check for PE>3.0.0
  if versioncmp($::pe_version, '3.0.0') >= 0 {
    class {'advanced::classroom::console':}
  }

  # Backup files and create default file then don't replace
  advanced::backup { $files_to_backup:
    delete => false,  
  } ->
  advanced::backup { $files_to_replace: } ->
  advanced::template { $files_to_replace :
    replace_file => false,
  }
  file { '/etc/puppetlabs/puppet/.mcollective_advanced_class':
    mode   => '0666',
    source => '/var/lib/peadmin/.mcollective',
  }

}
