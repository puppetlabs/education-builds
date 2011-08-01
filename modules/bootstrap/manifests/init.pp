class bootstrap {
  user { 'root':
    password => '$1$hgIZHl1r$tEqMTzoXz.NBwtW3kFv33/',
  }
  file { '/root/.bashrc':
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/bootstrap/root_bashrc',
    mode   => '0644',
  }
  yumrepo { 'puppetlabs':
    baseurl  => 'http://yum.puppetlabs.com/base/',
    enabled  => '0',
    gpgcheck => '0',
    descr    => 'Puppetlabs yum repo'
  }
  yumrepo { ['epel', 'updates', 'base']:
    enabled => 0,
  }
  service { 'sshd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
