# Add default memory settings after PE install

class learning::set_defaults {
  file { '/etc/puppetlabs/puppet/hieradata/defaults.yaml':
    ensure => present,
    source => 'puppet:///modules/learning/defaults.yaml',
  }
}

