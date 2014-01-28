# fundamentals::time - keeps master and agents in sync for training
#
# Warning: Do not use in production - this is a hack specifically for
# puppetlabs training courses
#
# Use: 
# 1) If an internet connection with port 123 open is available:
# `include fundamentals::time` 
# for all nodes, or classify all nodes with the class fundamentals::time
# to ensure:
#   a) The master is in sync with a timeserver from the ntp.org pool, and
#   b) the agents are in sync with the master
#   Since ntpdate is the only reliable way to set time in step (not slew) 
#     fashion, we use a cron job to automatically set master's time in sync 
#     with a timeserver in the ntp.org pool
#   Agents will use a cron job to sync with the master every 5 minutes
# 2) If an internet connection is not available:
# declare the class thus for all nodes:
# ` class { 'fundamentals::time': offline => 'true' }`
# or classify all nodes using an ENC with the fundamentals::time class 
# with the 'offline' parameter set to 'true'. This will:
#   a) ensure that the master's internal clock is the authoritative source
# for time, and
#   b) all agents are synced to the master via a cron task

class fundamentals::time ( $offline = 'false' ) {
  if $offline == 'true' {
    $time_servers = ['master.puppetlabs.vm']
  }
  else {
    $time_servers = ['0.pool.ntp.org iburst', '1.pool.ntp.org iburst', '2.pool.ntp.org iburst', '3.pool.ntp.org']
  }

  if $::hostname == 'master' {
    class { '::ntp':
       servers => $time_servers,
       panic   => false,
       udlc    => true,
    }
   # If we are online sync with a timeserver - handy for resuming class
   # allows time to be synced without slew, and without having to restart ntpd
    if $offline == 'false' {
      cron { 'synctime':
        command => "/usr/sbin/ntpdate -us ${time_servers[3]}",
        minute  => '*/5',
      }
    }
    # If we're offline, no point in repeatedly trying to sync 
    else {
      cron { 'synctime':
        ensure  => absent,
      }
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
      command => '/usr/sbin/ntpdate -s master.puppetlabs.vm',
      minute  => '*/5',
    }
  }
}
