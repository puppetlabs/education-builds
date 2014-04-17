class learning::install {
  exec {'install-pe':
    # This is a workaround for PE 3.2.0+ offline installations to work"
    # If you don't reset the rubylib, it'll inherit the one used during kickstart and the installer will blow up.
    environment => ["q_tarball_server=/usr/src/installer/","RUBYLIB=''"],
    command     => "/root/puppet-enterprise/puppet-enterprise-installer -D -a /root/learning.answers",
    creates     => '/usr/local/bin/puppet',
    logoutput   => true,
    timeout     => '14400',
  }

  # This rake task exists now! Hurray.
  exec {'reduce-activemq-heap':
    command     => '/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile node:variables name="learn.localdomain" variables="activemq_heap_mb=\"256\"" RAILS_ENV=production',
    logoutput   => true,
    environment => "RUBYLIB=''",
    require     => Exec['install-pe'],
    timeout     => '14400',
  }

  # So we'll make sure it exists:
  exec {'ensure learn.localdomain exists in console':
    command     => '/opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile node:add name="learn.localdomain" RAILS_ENV=production',
    returns     => [0,1], # It returns 1 if the node already exists, but the command is actually idempotent, so that's fine.
    logoutput   => true,
    environment => "RUBYLIB=''",
    require     => Exec['install-pe'],
    before      => Exec['reduce-activemq-heap'],
    timeout     => '14400',
  }

  # Add script that can print console login. Bootstrap will optionally call this in the rc.local file.
  file {'/root/.console_login.sh':
    ensure => file,
    source => 'puppet:///modules/learning/console_login.sh',
    mode   => '0755',
  }

  # Put examples in place -- we should have some way to automatically get the
  # most recent from the puppet docs source, where they'll be in
  # source/learning/files/examples.
  file {'/root/examples':
    ensure  => directory,
    source  => "puppet:///modules/${module_name}/examples",
    recurse => true,
  }

  file {'/etc/puppetlabs/puppet/modules/lvmguide':
    ensure   => directory,
    source   => "puppet:///modules/${module_name}/lvmguide",
    recurse  => true,
    require  => Exec['install-pe'],
  }

  # to use pe_gem to install the following gems, we first need pe_gem installed
  # using execs now till there is a more graceful solution
  
  exec { 'install trollop':
    command => '/opt/puppet/bin/gem install trollop -v 2.0',
    unless  => '/opt/puppet/bin/gem list trollop -i',
    require => Exec['install-pe'],
  }
  
  exec { 'install serverspec':
    command => '/opt/puppet/bin/gem install serverspec',
    unless  => '/opt/puppet/bin/gem list serverspec -i',
    require => Exec['install-pe'],
  }

}
