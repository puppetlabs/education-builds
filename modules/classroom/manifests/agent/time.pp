# Ensures that all agents are synced to the classroom master via a cron task
#
# Warning: Do not use in production - this is a hack specifically for
# puppetlabs training courses
#
# Use:
#   Classify all agent nodes
#
class classroom::agent::time {
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
