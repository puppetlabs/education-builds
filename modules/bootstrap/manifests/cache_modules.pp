class bootstrap::cache_modules(
  $cache_dir = '/usr/src/forge',
) {
  Bootstrap::Forge {
    cache_dir => $cache_dir,
  }

  file { $cache_dir:
    ensure => directory,
  }

  # These are the modules needed by the Fundamentals course

  # This is a temporary kludge as we transition from ripienaar-concat to puppetlabs
  # TODO: revisit this regularly and dump it when PE ships with this and all modules
  #       we use get updated to use this.
  bootstrap::forge { 'puppetlabs-concat':
    version => '1.1.1',
  }
  bootstrap::forge { 'camptocamp-augeasfacter':
    version => '0.1.0',
  }
  bootstrap::forge { 'domcleal-augeasproviders':
    version => '1.2.0',
  }
  bootstrap::forge { 'razorsedge-vmwaretools':
    version => '4.7.0',
  }
  bootstrap::forge { 'hunner-wordpress':
    version => '0.6.0',
  }
  bootstrap::forge { 'puppetlabs-mysql':
    version => '2.3.1',
  }
  bootstrap::forge { 'puppetlabs-apache':
    version => '1.1.1',
  }
  bootstrap::forge { 'thias-vsftpd':
    version => '0.2.1',
  }
  bootstrap::forge { 'puppetlabs-vcsrepo':
    version => '1.1.0',
  }
  bootstrap::forge { 'puppetlabs-ntp':
    version => '3.2.0',
  }
  bootstrap::forge { 'puppetlabs-haproxy':
    version => '1.0.0',
  }
  bootstrap::forge { 'jamtur01-irc':
    version => '0.0.7',
  }
  bootstrap::forge { 'hunner-charybdis':
    version => '1.0.0',
  }
  bootstrap::forge { 'puppetlabs-pe_gem':
    version => '0.0.1',
  }
  bootstrap::forge { 'stahnma-epel':
    version => '1.0.0',
  }
  bootstrap::forge { 'nanliu-staging':
    version => '1.0.0',
  }
  bootstrap::forge { 'puppetlabs/git':
    version => '0.2.0',
  }
  bootstrap::forge { 'zack/r10k':
    version => '2.3.0',
  }
  bootstrap::forge { 'zack/exports':
    version => '0.0.4',
  }
  # These are the additional modules needed by the extending puppet using ruby course
  # puppetlabs-mysql and puppetlabs-apache are also needed
}
