classroom::master::repository { 'test_repo':
  ensure => present,
  root => '/tmp/repositories',
  envroot => '/tmp/environments',
}

# This should fail due to regex sanity check (for environments) of name
classroom::master::repository { 'test-repo':
  ensure => present,
  root => '/tmp/repositories',
  envroot => '/tmp/environments',
}
