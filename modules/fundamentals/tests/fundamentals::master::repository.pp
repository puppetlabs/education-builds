
fundamentals::master::repository { 'test_repo':
  ensure => present,
  root => '/tmp/repositories',
  envroot => '/tmp/environments',
}

# This should fail due to regex sanity check (for environments) of name
fundamentals::master::repository { 'test-repo':
  ensure => present,
  root => '/tmp/repositories',
  envroot => '/tmp/environments',
}
