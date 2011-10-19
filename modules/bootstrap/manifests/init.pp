class bootstrap {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }
  user { 'root':
    password => '$1$hgIZHl1r$tEqMTzoXz.NBwtW3kFv33/',
  }
  file { '/root/bin':
    ensure => directory,
  }
  file { '/root/bin/envpuppet':
    source => 'puppet:///modules/bootstrap/envpuppet',
    mode   => '0755',
  }
  file { '/root/.bashrc':
    source => 'puppet:///modules/bootstrap/bashrc',
  }
  file { '/root/.emacs':
    source => 'puppet:///modules/bootstrap/emacs',
  }
  file { '/root/.emacs.d':
    source  => 'puppet:///modules/bootstrap/emacs.d',
    recurse => true,
  }
  file { '/root/.vim':
    ensure  => 'directory',
    source  => "/usr/src/puppet/ext/vim",
    recurse => true,
  }
  file { '/root/.vimrc':
    source => 'puppet:///modules/bootstrap/vimrc',
  }
  yumrepo { 'puppetlabs':
    baseurl  => 'http://yum.puppetlabs.com/base/',
    enabled  => '0',
    gpgcheck => '0',
    descr    => 'Puppetlabs yum repo'
  }
  yumrepo { ['epel', 'updates', 'base', 'extras', 'dvd']:
    enabled => 0,
  }
  service { 'sshd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  # puppetmaster bluetooth training
  service { 'hidd':
    ensure => stopped,
    enable => false,
    # hasstatus => broken
  } ->
  package { 'bluez-utils':
    ensure => absent,
  } ->
  package { 'bluez-libs':
    ensure => absent,
  }
}
