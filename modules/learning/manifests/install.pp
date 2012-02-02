class learning::install {
  exec {'install-pe':
    command     => "/root/puppet-enterprise/puppet-enterprise-installer -D -a /root/learning.answers",
    logoutput   => true,
    timeout     => '1800',
    environment => "RUBYLIB=''",
    # If you don't reset the rubylib, it'll inherit the one used during kickstart and the installer will blow up.
  }
}
