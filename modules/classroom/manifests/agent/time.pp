# Ensures that all agents are synced to the classroom master via a cron task
#
# Warning: Do not use in production - this is a hack specifically for
# puppetlabs training courses
#
# Use:
#   Classify all agent nodes
#
class classroom::agent::time {
  if $::osfamily == 'windows' {
    service { 'W32Time':
      ensure => running,
      enable => true,
    }
    exec { 'configure windows time service':
      command     => 'w32tm /register; w32tm /config /syncfromflags:MANUAL /manualpeerlist:master.puppetlabs.vm; w32tm /resync',
      path        => $::path,
      refreshonly => true,
      subscribe   => Service['W32Time'],
    }
    registry::value { 'ntp poll interval':
      key     => 'HKLM\SYSTEM\ControlSet001\Services\W32Time\TimeProviders\NtpClient',
      value   => 'SpecialPollInterval',
      type    => dword,
      data    => '300',
      require => Service['W32Time'],
    }
  }
  else {
    $service_name = $::osfamily ? {
      'debian' => 'ntp',
      default  => 'ntpd',
    }
    package { 'ntpdate':
      ensure => present,
    } ->
    service { $service_name:
      ensure => stopped,
    }
    # For agents, *always* stay true to the time on on the master
    cron { 'synctime':
      command => "/usr/sbin/ntpdate -s $::servername",
      minute  => '*/5',
    }
  }
}
