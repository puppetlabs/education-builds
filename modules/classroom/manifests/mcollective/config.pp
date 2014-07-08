class classroom::mcollective::config {
  include pe_mcollective

  # Each file to that must be duplicated should have an entry in an array here.
  # Each set of files that needs unique perms or ownership should have a variable
  # If you add a new variable, make sure to also edit client.pp & master.pp
  #
  # See http://docs.puppetlabs.com/mcollective/deploy/standard.html#step-5-configure-clients
  # for more info on configuring clients for mcollective

  # This list is more extensive than seems necessary. We overwrite the certificates that the
  # student installers generated. This is a huge hack, but it means that when students run
  # the agent against themselves, the same certificates get synced out so that agents maintain
  # connections to the classroom network.
  $ssl_certs = [
    "${::settings::ssldir}/certs/pe-internal-mcollective-servers.pem",
    "${::settings::ssldir}/private_keys/pe-internal-mcollective-servers.pem",
    "${::settings::ssldir}/public_keys/pe-internal-mcollective-servers.pem",
    "${::settings::ssldir}/public_keys/pe-internal-peadmin-mcollective-client.pem",
    "${::settings::ssldir}/public_keys/pe-internal-puppet-console-mcollective-client.pem",
  ]

  $peadmin = [
    "${pe_mcollective::params::mco_etc}/credentials",
    "/var/lib/peadmin/.mcollective",
    "/var/lib/peadmin/.mcollective.d/mcollective-public.pem",
    "/var/lib/peadmin/.mcollective.d/peadmin-private.pem",
    "/var/lib/peadmin/.mcollective.d/peadmin-public.pem",
    "/var/lib/peadmin/.mcollective.d/peadmin-cacert.pem",
    "/var/lib/peadmin/.mcollective.d/peadmin-cert.pem",
  ]

  $cachedir     = "${::settings::vardir}/mcollective_cache"
  $master_user  = 'pe-puppet'
  $master_group = 'pe-puppet'
  $stomp_server = 'master.puppetlabs.vm'
}
