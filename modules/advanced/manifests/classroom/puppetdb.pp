class advanced::classroom::puppetdb {
  # Add listen param so that we can see the PuppetDB Dashboard
  exec { 'node:addclassparam_pe_puppetdb_host' :
    path        => '/opt/puppet/bin:/bin',
    cwd         => '/opt/puppet/share/puppet-dashboard',
    environment => 'RAILS_ENV=production',
    command     => "rake node:addclassparam name=${::clientcert} class='pe_puppetdb::pe' param='listen_address' value='0.0.0.0'",
    unless      => "rake node:listclassparams name=${::clientcert} class='pe_puppetdb::pe' | grep -qs '^listen_address'",
    before      => Ini_setting['puppetdb_port'],
    notify      => Service['pe-puppetdb'],
  }

  # an evil, evil hack.
#  Ini_setting <| title == 'puppetdb_host' |> {
#    value => '0.0.0.0',
#  }

  # remove certificate_whitelist, else students won't be able to save facts
  ini_setting { 'puppetdb-certificate-whitelist':
    ensure  => absent,
    path    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
    section => jetty,
    setting => 'certificate-whitelist',
    notify  => Service['pe-puppetdb'],
  }
}
