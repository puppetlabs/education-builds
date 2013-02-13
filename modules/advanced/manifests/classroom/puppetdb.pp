# The puppetdb setup for classroom.puppetlabs.vm
class advanced::classroom::puppetdb {
  class { '::puppetdb':
    puppetdb_package => 'pe-puppetdb',
    puppetdb_service => 'pe-puppetdb',
    confdir          => '/etc/puppetlabs/puppetdb/conf.d',
  }
  class { 'puppetdb::master::config':
    puppetdb_server          => 'classroom.puppetlabs.vm',
    puppet_confdir           => '/etc/puppetlabs/puppet',
    terminus_package         => 'pe-puppetdb-terminus',
    puppet_service_name      => 'pe-httpd',
    puppetdb_startup_timeout => '60',
  }

  # This is a temp fix for 2.7.0 puppetdb bug
  $request_manager = 'request_manager'
  exec { "nodeclass:del ${request_manager}":
    path        => '/opt/puppet/bin:/bin',
    cwd         => '/opt/puppet/share/puppet-dashboard',
    environment => 'RAILS_ENV=production',
    command     => "rake nodeclass:del name=${request_manager}",
    onlyif      => "rake RAILS_ENV=production nodeclass:list | grep ${request_manager}",
    returns     => '1',
  }

}
