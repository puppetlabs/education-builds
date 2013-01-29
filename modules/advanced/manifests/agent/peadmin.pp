class advanced::agent::peadmin {
 file {'/var/lib/peadmin/.mcollective':
   owner   => 'peadmin',
   content => file('/etc/puppetlabs/puppet/.mcollective_advanced_class'),
 }
}
