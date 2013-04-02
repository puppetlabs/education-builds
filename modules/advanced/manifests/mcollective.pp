# Manage our wonky mcollective config for this course
class advanced::mcollective {
  # The rake API does not support removing a class from a group
  # So we remove the entire class from the console.
  $stomp_server = 'classroom.puppetlabs.vm'
  $stomp_credentials = file('/etc/puppetlabs/mcollective/credentials')

  exec { 'node:parameters':
    path        => '/opt/puppet/bin:/bin',
    cwd         => '/opt/puppet/share/puppet-dashboard',
    environment => 'RAILS_ENV=production',
    command     => "rake nodegroup:parameters name=default parameters=fact_stomp_server=${stomp_server},stomp_password=${stomp_credentials}",
    returns     => '0',
    subscribe   => File['/etc/puppetlabs/mcollective/credentials'],
    refreshonly => true,
  }
}
