# Ensures that the classroom master is the canonical source of time.

# Warning: Do not use in production - this is a hack specifically for
# puppetlabs training courses
#
# Use:
# 1) If an internet connection with port 123 open is available:
# `include classroom::time`
# for all nodes, or classify all nodes with the class classroom::time
# to ensure:
#   a) The master is in sync with a timeserver from the ntp.org pool, and
#   b) the agents are in sync with the master
#   Since ntpdate is the only reliable way to set time in step (not slew)
#     fashion, we use a cron job to automatically set master's time in sync
#     with a timeserver in the ntp.org pool
#   Agents will use a cron job to sync with the master every 5 minutes
# 2) If an internet connection is not available:
# declare the class thus for all nodes:
# ` class { 'classroom::time': offline => 'true' }`
# or classify all nodes using an ENC with the classroom::time class
# with the 'offline' parameter set to 'true'. This will:
#   a) ensure that the master's internal clock is the authoritative source
# for time, and
#   b) all agents are synced to the master via a cron task

class classroom::master::time (
  $offline      = $classroom::offline,
  $time_servers = $classroom::time_servers,
) inherits classroom {

  if $offline {
    # No point in repeatedly trying to sync if we don't have net
    $cronjob = absent
    # Set NTP service to consider itself authoritative
    $servers = [$::servername]
  }
  else {
    # Forcibly sync with a timeserver - handy for resuming class without slew
    $cronjob = present
    $servers = $time_servers
  }

  class { '::ntp':
     servers => $servers,
     panic   => false,
     udlc    => true,
  }

  cron { 'synctime':
    ensure  => $cronjob,
    command => "/usr/sbin/ntpdate -us ${time_servers[3]}",
    minute  => '*/5',
  }
}
