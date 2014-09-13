# This class enables directory environments on the master, and makes
# sure that it is set (at the defaults, in fact) to serve students' git
# repository contents as dynamic environments.

class classroom::master::directory_environments {

  # Add the environmentpath setting, so that directory environments
  # is enabled on the master.
  ini_setting { 'puppet.conf.environmentpath':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'main',
    setting => 'environmentpath',
    value   => '$confdir/environments',
    notify  => Service['pe-httpd'],
  }

  # Double-check our basemodulepath includes the main and PE modules.
  ini_setting { 'puppet.conf.basemodulepath':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'main',
    setting => 'basemodulepath',
    value   => '$confdir/modules:/opt/puppet/share/puppet/modules',
    notify  => Service['pe-httpd'],
  }

  # Disable environment caching, so students' last push is always used.
  ini_setting { 'puppet.conf.environmenttimeout':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'main',
    setting => 'environment_timeout',
    value   => '0',
    notify  => Service['pe-httpd'],
  }

  # Fake a production environment with a symlink to the main manifestdir
  file { '/etc/puppetlabs/puppet/environments/production':
    ensure => directory,
  }
  file { '/etc/puppetlabs/puppet/environments/production/manifests':
    ensure => link,
    target => '/etc/puppetlabs/puppet/manifests',
  }

}