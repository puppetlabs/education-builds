# Manage our wonky mcollective config for this course
class advanced::mcollective {
  # We need to set the following console parameters
  # The susbcribe is to ensure it only runs once -
  # The first time agent runs after classifying classroom with advanced
  $stomp_server = 'classroom.puppetlabs.vm'
  $stomp_credentials = file('/etc/puppetlabs/mcollective/credentials')

  exec { 'node:parameters':
    path        => '/opt/puppet/bin:/bin',
    cwd         => '/opt/puppet/share/puppet-dashboard',
    environment => 'RAILS_ENV=production',
    command     => "rake nodegroup:parameters name=default parameters=fact_stomp_server=${stomp_server},stomp_password=${stomp_credentials},fact_is_puppetmaster='false'",
    returns     => '0',
    subscribe   => File['/etc/puppetlabs/puppet/.mcollective_advanced_class'],
    refreshonly => true,
  }
}
