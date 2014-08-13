class lvmguide (
  $document_root = '/var/www/html/lvmguide',
  $port          = '80',
) {

  # Manage apache, the files for the website will be 
  # managed by the quest tool
  class { 'apache': 
    default_vhost => false,
  }
  apache::vhost { 'learning.puppetlabs.vm':
    port    => $port,
    docroot => $document_root,
  }
}
