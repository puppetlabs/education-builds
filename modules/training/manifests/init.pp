class training {
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

  # training repos
  yumrepo { 'puppetlabs':
    baseurl  => 'http://yum.puppetlabs.com/base/',
    enabled  => '0',
    gpgcheck => '0',
    descr    => 'Puppetlabs yum repo'
  }
  yumrepo { ['epel', 'updates', 'base', 'extras', 'dvd']:
    enabled => 0,
  }
}
