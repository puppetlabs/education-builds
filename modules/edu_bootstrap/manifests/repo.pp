class edu_bootstrap::repo {

    if $operatingsystemrelease <= '5.12' {
      $epelpackage = 'http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm'
    } elsif $operatingsystemrelease >= '6.0' {
      $epelpackage = 'http://mirror.metrocast.net/fedora/epel/6/i386/epel-release-6-7.noarch.rpm'
    }
    exec { 'install-epel':
      command => "/bin/rpm -i ${epelpackage}",
      creates => '/etc/yum.repos.d/epel.repo',
    }

    yumrepo { 'epel':
      descr          => 'Extra Packages for Enterprise Linux 5 - $basearch',
      enabled        => '1',
      failovermethod => 'priority',
      gpgcheck       => '1',
      gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL',
      mirrorlist     => 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-5&arch=$basearch',
      require        => Exec['install-epel'],
    }

    yumrepo { 'base':
      descr      => 'CentOS-$releasever - Base',
      enabled    => '1',
      gpgcheck   => '1',
      gpgkey     => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5',
      mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os',
    }

}
