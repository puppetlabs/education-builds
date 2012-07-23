define edu_bootstrap::console_class {

    exec { "add_console_class_${name}":
      path        => '/opt/puppet/bin:/bin',
      cwd         => '/opt/puppet/share/puppet-dashboard',
      environment => 'RAILS_ENV=production',
      command     => "rake nodeclass:add name=${name}",
      unless      => "rake RAILS_ENV=production nodeclass:list | grep ${name}",
    }

}
