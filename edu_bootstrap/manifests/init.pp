class edu_bootstrap {

  concat{ 'puppet_conf_concat':
    name  => '/etc/puppetlabs/puppet/puppet.conf',
    owner => 'pe-puppet',
    group => 'pe-puppet',
    mode  => '0644',
  }

  concat::fragment{ 'puppet_conf':
    target  => '/etc/puppetlabs/puppet/puppet.conf',
    source  => '/root/puppet.conf',
    order   => 01,
  }

  exec { 'cp_puppet_conf':
    command => '/bin/cp /etc/puppetlabs/puppet/puppet.conf /root/puppet.conf',
    unless  => '/usr/bin/test -f /root/puppet.conf',
    before  => Concat::Fragment['puppet_conf'],
  }

}
