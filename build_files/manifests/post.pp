# Run yum update before disabling repos
exec { 'yum -y update':
  path => '/bin:/usr/bin',
}

# Disable non-local yum repos
yumrepo { [ 'updates', 'base', 'extras', 'epel']:
  enabled             => '0',
  priority            => '99',
  skip_if_unavailable => '1',
  require             => Exec['yum -y update'],
}

yumrepo { 'puppetlabs-pc1':
  ensure => absent
}

# Delete cruft left by install process
file { [
  '/root/install.log',
  '/root/install.log.syslog',
  '/root/linux.iso',
  '/root/post.log',
  '/root/anaconda-ks.cfg'
]:
  ensure => absent,
}
