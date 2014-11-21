class learning {
  File {
    owner => root,
    group => root,
    mode  => 644,
  }

  file { '/root/learning.answers':
    ensure => file,
    source => 'puppet:///modules/learning/learning.answers',
  }

  # Print this info when we log in, too.
  file {'/etc/motd':
    ensure => file,
    owner  => root,
    mode   => 0644,
    source => 'puppet:///modules/learning/etc/motd',
  }

  package { 'tmux':
    ensure => present,
    require => Class['epel']
  }

  file { '/root/.tmux.conf':
    ensure => file,
    source => 'puppet:///modules/learning/tmux.conf',
  }

  file { '/root/README':
    ensure => file,
    source => 'puppet:///modules/learning/README',
  }

  file { '/root/bin':
    ensure => link,
    target => '/usr/src/puppetlabs-training-bootstrap/scripts/lvm',
  }

  file { '/root/.testing':
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/learning/.testing',
    ignore  => [ 'log.yml','test.rb'],
  }
  
  file { '/root/.testing/log.yml':
    ensure  => file,
    source  => 'puppet:///modules/learning/.testing/log.yml',
    replace => false,
  }
  
  file { '/root/.testing/test.rb':
    ensure => file,
    source => 'puppet:///modules/learning/.testing/test.rb',
    mode   => '0755',
  }

  file { '/root/setup':
    ensure  => directory,
    source  => 'puppet:///modules/learning/setup',
    mode    => '0755',
    recurse => true,
  }

  file { '/var/lib/hiera':
    ensure => directory,
  }
  file { '/var/lib/hiera/defaults.yaml':
    ensure => file,
    source => 'puppet:///modules/learning/defaults.yaml',
    require => File['/var/lib/hiera'],
  }

}

