class advanced::classroom::puppetdb {
  class { '::puppetdb':
    puppetdb_package => 'pe-puppetdb',
    puppetdb_service => 'pe-puppetdb',
    confdir          => '/etc/puppetlabs/puppetdb/conf.d',
  }
  class { 'puppetdb::master::config':
    puppetdb_server     => 'classroom.puppetlabs.vm',
    puppet_confdir      => '/etc/puppetlabs/puppet',
    terminus_package    => 'pe-puppetdb-terminus',
    puppet_service_name => 'pe-httpd',
  }
}
