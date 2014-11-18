# This only thing this class does is handoff the student Agent node to that student's
# Master node, while retaining the ca_server connection back to the classroom CA
class classroom::tier3(
  $etcpath      = $classroom::params::etcpath,
) inherits classroom::params {
  ini_setting { 'puppet.conf.server':
    ensure  => present,
    path    => "${etcpath}/puppet.conf",
    section => 'agent',
    setting => 'server',
    value   => $::domain,
  }

  ini_setting { 'puppet.conf.caserver':
    ensure  => present,
    path    => "${etcpath}/puppet.conf",
    section => 'main',
    setting => 'ca_server',
    value   => $::servername,
  }

  Host <<| title == $::domain |>>
  Host <<| title == 'proxy.puppetlabs.vm' |>>

  notify { "Redirecting this agent to the ${::domain} master": }
}
