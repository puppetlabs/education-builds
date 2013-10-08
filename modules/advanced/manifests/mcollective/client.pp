class advanced::mcollective::client {
  # Ensure the existence of files on the client machines that come from the master.
  # Define files that should be copied from the master in config.pp
  # Any sets of files that need unique permissions or ownership should have a
  # separate array variable defined.
  include advanced::mcollective::config

  # chicken & egg with pe_mcollective. Only restart if it's already been classified
  if defined(Service['pe-mcollective']) {
    Advanced::Mcollective::File {
      notify => Service['pe-mcollective'],
    }
  }

  advanced::mcollective::file { $advanced::mcollective::config::ssl_certs:
    ensure => file,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '640',
  }

  advanced::mcollective::file { $advanced::mcollective::config::peadmin:
    ensure => file,
    owner  => 'peadmin',
    group  => 'peadmin',
    mode   => '644',
  }
}
