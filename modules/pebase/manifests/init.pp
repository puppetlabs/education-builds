class pebase {
  file { '/root/puppet-enterprise':
    ensure => symlink,
    target => "/root/puppet-enterprise-${::pe_version}-el-5-i386",
  }
}
