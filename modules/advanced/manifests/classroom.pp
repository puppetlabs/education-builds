class advanced::classroom {
  include pe_mcollective
  # These are the files that we manage with this class
  $managed_files = [
    '/etc/puppetlabs/puppet/auth.conf',
    '/etc/puppetlabs/puppet/manifests/site.pp',
  ]

  class {'advanced::classroom::hostname':} ->
  class {'advanced::classroom::puppetdb':} ->
  class {'advanced::mcollective':} ->
  class {'advanced::irc::client':}

  # Backup and create default file then don't replace
  advanced::backup   { $managed_files :} ->
  advanced::template { $managed_files :
    replace_file => false,
  }
  file { '/etc/puppetlabs/puppet/.mcollective_advanced_class':
    mode   => '666',
    source => '/var/lib/peadmin/.mcollective',
  }


  # Enable autosigning to simplify exercises

  $autosign_file = '/etc/puppetlabs/puppet/autosign.conf'
  file { $autosign_file:
    ensure  => file,
    content => template("${module_name}${autosign_file}.erb"),
  }

  # Setup the wordpress class for exercise 2.2
  exec { 'nodeclass:add wordpress':
    path        => '/opt/puppet/bin:/bin',
    cwd         => '/opt/puppet/share/puppet-dashboard',
    environment => 'RAILS_ENV=production',
    command     => 'rake nodeclass:add name=wordpress',
    unless      => 'rake RAILS_ENV=production nodeclass:list | grep wordpress',
    returns     => '1',
  }

}
