define bootstrap::copymod(
  $pe_modules_path = '/root/puppet-enterprise/modules',
  $tar_source_path = '/usr/src/puppetlabs-training-bootstrap/modules',
){
  $archive_path = "${pe_modules_path}/${name}.tar.gz"
  $source_path  = "${tar_source_path}/${name}"

  exec { "puppet-enterprise/modules/${name}":
    path        => '/bin',
    command     => "tar -czf ${archive_path} ${source_path}",
    refreshonly => true,
  }
  file_line { "puppet-enterprise/modules/${name}":
    path     => '/root/puppet-enterprise/modules/install_modules.txt',
    line     => $name,
    notify   => Exec["puppet-enterprise/modules/${name}"],
  }
}
