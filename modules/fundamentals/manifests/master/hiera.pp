# You can use this if you're lazy and/or don't remember
# the yaml syntax. It's preferred to type it out.
# Drives the point home how easy it is to configure.
#
# ### This is not idempotent, so don't classify the master
#
class fundamentals::master::hiera {
  file { '/etc/puppetlabs/puppet/hieradata/defaults.yaml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('fundamentals/teams.yaml.erb'),
    replace => false,
  }
}
