file { '/tmp/forge':
  ensure => directory,
}

fundamentals::forge { 'saz-sudo':
  cache_dir => '/tmp/forge',
}

fundamentals::forge { 'puppetlabs-stdlib':
  cache_dir => '/tmp/forge',
}
