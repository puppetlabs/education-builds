# This only thing this class does is reset the agent's server setting
# to redirect it to that student's master
class classroom::tier3 {
  augeas {"puppet.conf.agent":
    context => "/files/etc/puppetlabs/puppet/puppet.conf/agent",
    changes => "set server ${domain}",
  }

  Host <<| title == $::domain |>>

  notify { "Redirecting this agent to the ${::domain} master": }
}
