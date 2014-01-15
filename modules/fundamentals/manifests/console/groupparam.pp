define fundamentals::console::groupparam (
  $group,
  $class,
  $param,
  $value,
  $force = false,
) {
    $guard = $force ? {
      true  => undef,
      false => "rake nodegroup:listclassparams name=${group} class=${class} | grep ${param}",
    }

    exec { "add_console_group_param_${name}":
      path        => '/opt/puppet/bin:/bin',
      cwd         => '/opt/puppet/share/puppet-dashboard',
      environment => 'RAILS_ENV=production',
      command     => "rake nodegroup:addclassparam name=${group} class=${class} param=${param} value=${value}",
      unless      => $guard,
    }

}
