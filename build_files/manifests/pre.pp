# Run yum update before disabling repos
exec { 'yum -y update':
  path => '/bin:/usr/bin',
}

# Disable local yum repos
yumrepo { [ 'updates_local', 'base_local', 'extras_local', 'epel_local']:
  enabled             => '0',
  priority            => '99',
  skip_if_unavailable => '1',
  require             => Exec['yum -y update'],
}

# Enable non-local yum repos
yumrepo { [ 'updates', 'base', 'extras', 'epel']:
  enabled             => '1',
  skip_if_unavailable => '1',
  require             => Exec['yum -y update'],
}
