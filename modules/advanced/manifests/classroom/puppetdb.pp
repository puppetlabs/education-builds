# The puppetdb setup for classroom.puppetlabs.vm
class advanced::classroom::puppetdb {
  # PE < 3.0.0 did not have the pe_puppetdb class
  if versioncmp($::pe_version, '3.0.0') < 0 {
    class { '::puppetdb':
      puppetdb_package => 'pe-puppetdb',
      puppetdb_service => 'pe-puppetdb',
      confdir          => '/etc/puppetlabs/puppetdb/conf.d',
      listen_address   => '0.0.0.0',
    }
    class { 'puppetdb::master::config':
      puppetdb_server          => 'classroom.puppetlabs.vm',
      puppet_confdir           => '/etc/puppetlabs/puppet',
      terminus_package         => 'pe-puppetdb-terminus',
      puppet_service_name      => 'pe-httpd',
      puppetdb_startup_timeout => '60',
    }
  }
  # For 3.0.0 and higher, we need to add a listen_address class param
  # also, remove certificate_whitelist, else others won't be able to save facts
  else {
    exec { 'node:addclassparam_pe_puppetdb_host' :
      path        => '/opt/puppet/bin:/bin',
      cwd         => '/opt/puppet/share/puppet-dashboard',
      environment => 'RAILS_ENV=production',
      command     => "rake node:addclassparam name=${::clientcert} class='pe_puppetdb' param='listen_address' value='0.0.0.0'",
      unless      => "rake node:listclassparams name=${::clientcert} class='pe_puppetdb' | grep -qs '^listen_address'",
      before      => Ini_setting['puppetdb_port'],
      notify      => Service['pe-puppetdb']]
    }
    ini_setting { 'puppetdb-certificate-whitelist':
      ensure  => absent,
      path    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
      section => jetty,
      setting => 'certificate-whitelist',
      notify  => Service['pe-puppetdb'],
    }
  }
}
