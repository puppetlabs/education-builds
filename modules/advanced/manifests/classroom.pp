# Main class applied to classroom
class advanced::classroom {
  include kickstand
  include advanced::classroom::fileserver
  # These are the files that we manage with this class
  $managed_files = [
    '/etc/puppetlabs/puppet/auth.conf',
    '/etc/puppetlabs/puppet/manifests/site.pp',
    '/etc/puppetlabs/console-auth/config.yml',
    '/etc/puppetlabs/rubycas-server/config.yml'
  ]

  if versioncmp($::pe_version, '3.0.0') < 1 {
    class {'advanced::classroom::puppetdb':} 
  }

  class {'advanced::mcollective':} 
  class {'advanced::irc::client':}
  class {'advanced::classroom::console':}

  # Backup and create default file then don't replace
  advanced::backup   { $managed_files :} ->
  advanced::template { $managed_files :
    replace_file => false,
  }
  file { '/etc/puppetlabs/puppet/.mcollective_advanced_class':
    mode   => '0666',
    source => '/var/lib/peadmin/.mcollective',
  }

  # Setup the wordpress class for exercise 2.2
  exec { 'nodeclass:add wordpress':
    path        => '/opt/puppet/bin:/bin',
    cwd         => '/opt/puppet/share/puppet-dashboard',
    environment => 'RAILS_ENV=production',
    command     => 'rake nodeclass:add name=wordpress',
    unless      => 'rake RAILS_ENV=production nodeclass:list | grep wordpress',
    #returns     => '1',
  }

}
