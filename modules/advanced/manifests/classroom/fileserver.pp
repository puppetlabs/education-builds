class advanced::classroom::fileserver {

  File {
    ensure => file,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0440',
  }

  # Manage fileserver.conf, initially for the capstone
  file { '/etc/puppetlabs/puppet/fileserver.conf':
    source => 'puppet:///modules/advanced/fileserver.conf',
  }

  # Create symlink directory so that public SSL files are accessible
  file { '/etc/puppetlabs/puppet/ssl_public':
    ensure => directory,
  }

  file { '/etc/puppetlabs/puppet/ssl_public/crl.pem':
    source => '/etc/puppetlabs/puppet/ssl/crl.pem',
  }
}
