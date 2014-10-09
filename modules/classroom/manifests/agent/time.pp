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
    }
  }
  else {
    package { 'ntpdate':
      ensure => present,
    } ->
    service { 'ntpd':
      ensure => stopped,
    }
    # For agents, *always* stay true to the time on on the master
    cron { 'synctime':
      command => "/usr/sbin/ntpdate -s $::servername",
      minute  => '*/5',
    }
  }
}
