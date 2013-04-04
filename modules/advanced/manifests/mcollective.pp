# Manage our wonky mcollective config for this course
class advanced::mcollective {
  # We need to set the following console parameters
  # The susbcribe is to ensure it only runs once -
  # The first time agent runs after classifying classroom with advanced
  $stomp_server = 'classroom.puppetlabs.vm'
  $stomp_credentials = file('/etc/puppetlabs/mcollective/credentials')

  Exec {
    path        => '/opt/puppet/bin:/bin',
    cwd         => '/opt/puppet/share/puppet-dashboard',
    environment => 'RAILS_ENV=production',
    returns     => '0',
    subscribe   => File['/etc/puppetlabs/puppet/.mcollective_advanced_class'],
    refreshonly => true,
  }
  
  exec { 'node:parameters:fact_stomp_server':
    command     => "rake nodegroup:parameters name=default parameters=fact_stomp_server=${stomp_server}",
  }

  exec { 'node:parameters:stomp_credentials':
    command     => "rake nodegroup:parameters name=default parameters=stomp_credentials=${stomp_credentials}",
  }

  exec { 'node:parameters:fact_is_puppetmaster':
    command     => "rake nodegroup:parameters name=default parameters=fact_is_puppetmaster='false'",
  }

}
