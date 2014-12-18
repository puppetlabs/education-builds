class learning::set_swap {
  augeas { "swap settings":
    context => "/files/etc/sysctl.conf",
    changes => [
      "set vm.overcommit_memory 2",
      "set vm.swappiness 75",
    ],
    before => [Class['learning::install'],Class['bootstrap::get_pe'],
  }
  exec { 'sysctl -p':
    path => '/sbin/',
    require => Augeas['swap settings'],
  }
}
