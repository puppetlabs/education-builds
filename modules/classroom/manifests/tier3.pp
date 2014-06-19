# This only thing this class does is handoff the student Agent node to that student's
# Master node, while retaining the ca_server connection back to the classroom CA
class classroom::tier3 {
  ini_setting { 'puppet.conf.server':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'agent',
    setting => 'server',
    value   => $::domain,
  }

  ini_setting { 'puppet.conf.caserver':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'main',
    setting => 'ca_server',
    value   => $::servername,
  }

  Host <<| title == $::domain |>>

  notify { "Redirecting this agent to the ${::domain} master": }
}
