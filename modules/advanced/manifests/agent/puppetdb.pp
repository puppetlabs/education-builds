# Configure students with puppetdb
class advanced::agent::puppetdb {
    class { 'puppetdb::master::config':
      puppetdb_server     => 'classroom.puppetlabs.vm',
      puppet_confdir      => '/etc/puppetlabs/puppet',
      terminus_package    => 'pe-puppetdb-terminus',
      puppet_service_name => 'pe-httpd',
    }
}
