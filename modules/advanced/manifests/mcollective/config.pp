class advanced::mcollective::config {
  # Each file to that must be duplicated should have an entry in an array here.
  # Each set of files that needs unique perms or ownership should have a variable
  # If you add a new variable, make sure to also edit client.pp & master.pp
  #
  # See http://docs.puppetlabs.com/mcollective/deploy/standard.html#step-5-configure-clients
  # for more info on configuring clients for mcollective

  $ssl_certs = [
    '/etc/puppetlabs/puppet/ssl/certs/pe-internal-mcollective-servers.pem',
  ]

  $peadmin = [
    '/etc/puppetlabs/mcollective/credentials',
    '/var/lib/peadmin/.mcollective',
    '/var/lib/peadmin/.mcollective.d/mcollective-public.pem',
    '/var/lib/peadmin/.mcollective.d/peadmin-private.pem',
    '/var/lib/peadmin/.mcollective.d/peadmin-public.pem',
    '/var/lib/peadmin/.mcollective.d/peadmin-cacert.pem',
    '/var/lib/peadmin/.mcollective.d/peadmin-cert.pem',
  ]

  $cachedir     = "${::settings::vardir}/mcollective_cache"
  $master_user  = 'pe-puppet'
  $master_group = 'pe-puppet'
}
