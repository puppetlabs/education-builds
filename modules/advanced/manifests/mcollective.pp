class advanced::mcollective {
  # The rake API does not support removing a class from a group
  # So we remove the entire class from the console.
  $pe_mollective = 'pe_mcollective'
  exec { "nodeclass:del ${pe_mollective}":
    path        => '/opt/puppet/bin:/bin',
    cwd         => '/opt/puppet/share/puppet-dashboard',
    environment => 'RAILS_ENV=production',
    command     => "rake nodeclass:del name=${pe_mollective}",
    onlyif      => "rake RAILS_ENV=production nodeclass:list | grep ${pe_mollective}",
    returns     => '1',
    notify      => Exec['node:parameters'],
  }


  $stomp_server = 'classroom.puppetlabs.vm'

  exec { 'node:parameters':
    path        => '/opt/puppet/bin:/bin',
    cwd         => '/opt/puppet/share/puppet-dashboard',
    environment => 'RAILS_ENV=production',
    command     => "rake node:parameters name=$stomp_server parameters=fact_is_puppetmaster=true",
    returns     => '1',
    refreshonly => true,
  }
}
