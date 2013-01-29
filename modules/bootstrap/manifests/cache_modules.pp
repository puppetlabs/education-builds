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

  bootstrap::forge { 'camptocamp-augeasfacter': 
    version => '0.1.0',
  }
  bootstrap::forge { 'domcleal-augeasproviders': 
    version => '0.5.1',
  }
  bootstrap::forge { 'cprice404-inifile': 
    version => '0.9.0',
  }
  bootstrap::forge { 'razorsedge-vmwaretools': 
    version => '4.2.0',
  }
  bootstrap::forge { 'hunner-wordpress': 
    version => '0.3.0',
  }
  bootstrap::forge { 'puppetlabs-mysql': 
    version => '0.6.1',
  }
  bootstrap::forge { 'puppetlabs-apache': 
    version => '0.5.0-rc1',
  }
  bootstrap::forge { 'thias-vsftpd': 
    version => '0.1.1',
  }
  bootstrap::forge { 'puppetlabs-firewall': 
    version => '0.0.4',
  }
  bootstrap::forge { 'saz-sudo': 
    version => '2.1.0',
  }

  # These are the additional modules needed by the Advanced course
  # puppetlabs-mysql is also needed
  bootstrap::forge { 'zack-haproxy': 
    version => '0.2.0',
  }
  bootstrap::forge { 'zack-irc': 
    version => '0.0.4',
  }
  bootstrap::forge { 'hunner-charybdis': 
    version => '0.2.0',
  }
  bootstrap::forge { 'puppetlabs-puppetdb': }
  

  # These are the additional modules needed by the extending puppet using ruby course
  # puppetlabs-mysql and puppetlabs-apache are also needed

}
