class training {
  # training repos
  yumrepo { 'puppetlabs':
    baseurl  => 'http://yum.puppetlabs.com/base/',
    enabled  => '1',
    priority => '99',
    gpgcheck => '0',
    descr    => 'Puppetlabs yum repo'
  }
  augeas { 'enable_yum_priorities':
    context => '/files/etc/yum/pluginconf.d/priorities.conf/main',
    changes => [
      "set enabled 1",
    ],
  }
  yumrepo { ['epel', 'updates', 'base', 'extras']:
    enabled  => '1',
    priority => '99',
  }
}
