class learning::install {
  exec {'install-pe':
    command     => "/root/puppet-enterprise/puppet-enterprise-installer -D -a /root/learning.answers",
    logoutput   => true,
    timeout     => '1800',
    environment => "RUBYLIB=''",
    # If you don't reset the rubylib, it'll inherit the one used during kickstart and the installer will blow up.
  }

  # This rake task exists now! Hurray.
  exec {'reduce-activemq-heap':
    command     => '/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile node:parameters name=learn.localdomain parameters="activemq_heap_mb=256" RAILS_ENV=production',
    logoutput   => true,
    environment => "RUBYLIB=''",
    require     => Exec['install-pe'],
  }
}
