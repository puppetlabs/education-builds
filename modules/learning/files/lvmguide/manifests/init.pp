class lvmguide (
  $document_root = '/var/www/html/lvmguide',
  $port          = '80',
) {
  class { 'apache': 
    default_vhost => false,
  }
  apache::vhost { 'learning.puppetlabs.vm':
    port    => $port,
    docroot => $document_root,
  }
  file { '/var/www/html/lvmguide':
    ensure  => directory,
    owner   => $::apache::params::user,
    group   => $::apache::params::group,
    source  => 'puppet:///modules/lvmguide/html',
    recurse => true,
    require => Class['apache'],
  }
}
