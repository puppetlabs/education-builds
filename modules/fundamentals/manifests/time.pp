class fundamentals::time ( $offline = false ) {

  case $offline {
    true: {
      if $::hostname == 'master' {
        class { '::ntp':
           servers => ['master.puppetlabs.vm'],
           panic   => false,
           udlc    => $enable_udlc,
        }
      }
      else {
        package { 'ntpdate':
          ensure => present,
        } ->
        service { 'ntpd':
          ensure => stopped,
        }
        cron { 'synctime':
          command => '/usr/bin/ntpdate master.puppetlabs.vm',
          minute  => '*/5',
        }
      }
    }
    false: {
      class { '::ntp':
          panic => false,
      }
    }
  }
}
