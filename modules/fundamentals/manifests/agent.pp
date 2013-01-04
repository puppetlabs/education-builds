class fundamentals::agent {
  $set_domain   = "puppetlabs.vm"
  $set_fqdn     = "${::set_hostname}.${set_domain}"

  # If we are still in the first boot state
  host { "${set_fqdn}":
    ensure       => present,
    ip           => $::ipaddress,
    host_aliases => [$::set_hostname],
  }

  # Set our persistant hostname
  file { '/etc/sysconfig/network':
    ensure  => file,
    content => template("${module_name}/network.erb"),
    require => Host[$set_fqdn],
  }

  service { 'network':
    ensure    => running,
    hasstatus => true,
    enable    => true,
    subscribe => File['/etc/sysconfig/network'],
  }

  # Set our current hostname
  if $::fqdn != $set_fqdn {
    exec { 'hostname':
        path    => '/bin',
        cwd     => '/root',
        command => "hostname ${set_fqdn}",
        require => Host["${set_fqdn}"],
    }
  }

  # Enable base repo when we are doing the capstone
  if str2bool($::yumrepo_base_enabled) {
    $yumrepo_base = 1
  } else {
    $yumrepo_base = 0
  }

  yumrepo { 'base':
    enabled => $yumrepo_base,
  }
}
