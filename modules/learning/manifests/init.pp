class learning {
  File {
    owner => root,
    group => root,
    mode  => 644,
  }
  Exec {
    path => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    cwd  => '/',
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
    source => 'puppet:///modules/learning/README',
  }

  # Install apache2 httpd so the directories exist
  package { 'httpd':
    ensure => present,
    require => Class['localrepo']
  }

  # Create docroot for lvmguide files, so the website files
  # can be put in place
  file { '/var/www/html/lvmguide':
    ensure  => directory,
    owner   => 'apache',
    group   => 'apache',
    mode    => '755',
    require => Package['httpd'],
  }

  package { 'tmux':
    ensure => present,
    require => Class['localrepo']
  }

  file { '/root/README':
    ensure => file,
    source => 'puppet:///modules/learning/README',
  }

  file { '/root/bin':
    ensure => directory,
  }

  vcsrepo { "/usr/src/courseware-lvm":
    ensure   => present,
    provider => git,
    source   => 'git://github.com/puppetlabs/courseware-lvm.git',
    revision => 'upcoming',
  }


  file { '/root/bin/quest':
    ensure  => file,
    mode    => '0755',
    source  => "/usr/src/courseware-lvm/quest_tool/bin/quest",
    require => Vcsrepo['/usr/src/courseware-lvm'],
  }

  exec { 'update_content':
    command => '/root/bin/quest update',
    creates => '/root/.testing/VERSION',
    require => File['/root/bin/quest'],
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
