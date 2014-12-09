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

  exec { 'download_quest_tool':
    command => 'wget --no-check-certificate https://raw.githubusercontent.com/puppetlabs/courseware-lvm/master/quest_tool/bin/quest',
    cwd     => '/root/bin',
    creates => '/root/bin/quest',
    require => File['/root/bin'],
  }

  file { '/root/bin/quest':
    ensure  => file,
    mode    => '0755',
    require => Exec['download_quest_tool'],
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
