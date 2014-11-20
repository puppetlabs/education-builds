class bootstrap ($print_console_login = false) {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  # yum repos
  yumrepo { 'puppetlabs':
    baseurl             => 'http://yum.puppetlabs.com/el/6/products/$basearch/',
    enabled             => '0',
    priority            => '99',
    gpgcheck            => '0',
    skip_if_unavailable => '1',
    descr               => 'Puppetlabs yum repo'
  }
  package { 'yum-plugin-priorities':
    ensure => installed,
  }
  package { 'yum-utils':
    ensure => installed,
  }
  package { 'wget':
    ensure => installed,
  }
  augeas { 'enable_yum_priorities':
    context => '/files/etc/yum/pluginconf.d/priorities.conf/main',
    changes => [
      "set enabled 1",
    ],
    require => Package['yum-plugin-priorities'],
  }
  yumrepo { [ 'updates', 'base', 'extras']:
    enabled  => '1',
    priority => '99',
    skip_if_unavailable => '1',
  }

  # Moving the root user declaration to the userprefs module.
  # user { 'root':
  #   password => '$1$hgIZHl1r$tEqMTzoXz.NBwtW3kFv33/',
  # }
  file { '/usr/bin/envpuppet':
    source => 'puppet:///modules/bootstrap/envpuppet',
    mode   => '0755',
  }

  # This is the thing Dom came up with to print the IP to the TTY
  file {'/root/.ip_info.sh':
    ensure => file,
    source => 'puppet:///modules/bootstrap/ip_info.sh',
    mode   => 0755,
  }
  # This script generates the initial root SSH key for the fundamentals git workflow
  if $print_console_login == false {
    file { '/root/.ssh_keygen.sh':
      ensure => file,
      source => 'puppet:///modules/bootstrap/ssh_keygen.sh',
      mode   => 0755,
    }
  }
  # This shouldn't change anything, but want to make sure it actually IS laid out the way I expect.
  file {'/etc/rc.local':
    ensure => symlink,
    target => 'rc.d/rc.local',
    mode   => 0755,
  }
  # Make sure we run the ip_info script.
  file {'/etc/rc.d/rc.local':
    ensure  => file,
    content => template('bootstrap/rc.local.erb'),
    mode    => 0755,
  }
  service { 'sshd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
  # Add a few extra packages for convenience
  package { [ 'patch', 'screen', 'telnet', 'tree' ] :
    ensure  => present,
    require => Class['localrepo'],
  }

  # need rubygems to cache rubygems
  package { 'rubygems' :
    ensure  => present,
    require => Class['localrepo'],
    before  => Class['bootstrap::cache_gems'],
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

  # Disable GSS-API for SSH to speed up log in
  $ruby_aug_package = $::osfamily ? {
    'RedHat' => 'ruby-augeas',
    'Debian' => 'libaugeas-ruby',
  }

  package { 'ruby_augeas_lib':
    ensure  => 'present',
    name    => $ruby_aug_package,
    require => Class['localrepo']
  }

  augeas { "GSSAPI_disable":
    context => '/files/etc/ssh/sshd_config',
    changes => 'set GSSAPIAuthentication no',
  }

  # Cache forge modules locally in the vm:
  class { 'bootstrap::cache_modules': cache_dir => '/usr/src/forge' }

  # Cache gems locally in the vm:
  class { 'bootstrap::cache_gems': }

  # configure user environment
  include userprefs::defaults

}
