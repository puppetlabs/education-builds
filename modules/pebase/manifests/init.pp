class pebase {
  file { '/root/puppet-enterprise':
    ensure => symlink,
    target => '/root/puppet-enterprise-2.0.2-el-5-i386',
  }
}
