# Manifest for post build cleanup

# Disable non-local yum repos
yumrepo { [ 'updates', 'base', 'extras', 'epel']:
  enabled  => '0',
  priority => '99',
  skip_if_unavailable => '1',
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

