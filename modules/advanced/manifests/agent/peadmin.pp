# Manage the .mcollective file so students can use mco
class advanced::agent::peadmin {
  file {'/var/lib/peadmin/.mcollective':
    owner   => 'peadmin',
    content => file('/etc/puppetlabs/puppet/.mcollective_advanced_class'),
  }
}
