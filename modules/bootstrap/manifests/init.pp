class bootstrap {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }
  user { 'root':
    password => '$1$hgIZHl1r$tEqMTzoXz.NBwtW3kFv33/',
  }
  file { '/usr/bin/envpuppet':
    source => 'puppet:///modules/bootstrap/envpuppet',
    mode   => '0755',
  }
  file { '/root/.bashrc':
    source => 'puppet:///modules/bootstrap/bashrc',
  }
  file { '/root/.emacs':
    source => 'puppet:///modules/bootstrap/emacs',
  }
  file { '/root/.emacs.d':
    source  => 'puppet:///modules/bootstrap/emacs.d',
    recurse => true,
  }
  file { '/root/.vim':
    ensure  => 'directory',
    source  => "/usr/src/puppet/ext/vim",
    recurse => true,
  }
  file { '/root/.vimrc':
    source => 'puppet:///modules/bootstrap/vimrc',
  }
  # This is the thing Dom came up with to print the IP to the TTY
  file {'/root/.ip_info.sh':
    ensure => file,
    source => 'puppet:///modules/bootstrap/ip_info.sh',
    mode   => 0755,
  }
  # This shouldn't change anything, but want to make sure it actually IS laid out the way I expect.
  file {'/etc/rc.local':
    ensure => symlink,
    target => 'rc.d/rc.local',
    mode   => 0755,
  }
  # Make sure we run the ip_info script.
  file {'/etc/rc.d/rc.local':
    ensure => file,
    source => 'puppet:///modules/bootstrap/rc.local',
    mode   => 0755,
  }
  service { 'sshd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  # Hostname setup:
  # 1. Make sure our own hostname resolves.
  # 2. If our hostname isn't localhost.localdomain, then we had to contaminate
  #    localhost during kickstart. Restore localhost to its default state.
  if $::fqdn != 'localhost.localdomain' {
    host { 'localhost.localdomain':
      ensure       => present,
      ip           => '127.0.0.1',
      host_aliases => ['localhost'],
    }
  }

  file { '/etc/sysconfig/network':
    ensure  => file,
    content => template('bootstrap/network.erb'),
  }
  service { 'network':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/sysconfig/network'],
    hasstatus => true,
  }

  # /etc/puppet/ssl is confusing to have around. Sloppy. Kill.
  file {'/etc/puppet':
    ensure  => absent,
    recurse => true,
    force   => true,
  }

  service { 'nscd':
    ensure => stopped,
    enable => false,
  }

  # An array of modules to copy from /usr/src to PE /opt/puppet
  #bootstrap::copymod{ ['fundamentals','concat']:
  #  require => Class['pebase'],
  #}
}
