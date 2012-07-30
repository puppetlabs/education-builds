class fundamentals::nfs::server {
  package {['nfs-utils','nfs-utils-lib']:
    ensure => installed,
  }
  service {'nfs':
    ensure  => running,
    enable  => true,
    restart => '/sbin/service nfs reload',
    require => [Package['nfs-utils'],Package['nfs-utils-lib']],
  }
  file {'/etc/exports':
    ensure  => file,
    content => template("fundamentals/nfs/server/exports.erb"),
    notify  => Service['nfs'],
  }
}
