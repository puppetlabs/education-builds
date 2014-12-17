class learning::set_swap {
  augeas { "swap settings":
    context => "/files/etc/sysctl.conf",
    changes => [
      "set vm.overcommit_memory 2",
    ],
    before => Class['learning::install'],
  }
  exec { 'sysctl -p':
    path => '/sbin/',
    require => Augeas['swap settings'],
  }
}
