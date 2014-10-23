define classroom::console::groupparam (
  $group,
  $classname,
  $parameter,
  $value,
) {
  exec { "add_console_group_param_${name}":
    path        => '/opt/puppet/bin:/bin',
    cwd         => '/opt/puppet/share/puppet-dashboard',
    environment => 'RAILS_ENV=production',
    command     => "bundle exec rake nodegroup:addclassparam['${group}','${classname}','${parameter}','${value}']",
    unless      => "bundle exec rake nodegroup:listclassparams['${group}','${classname}'] | grep ${parameter}",
  }
}
