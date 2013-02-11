file { '/tmp/forge':
  ensure => directory,
}

bootstrap::forge { 'saz-sudo':
  cache_dir => '/tmp/forge',
}

bootstrap::forge { 'puppetlabs-stdlib':
  cache_dir => '/tmp/forge',
}
