# Makes a class available to the PE Console
#
# This is no longer needed in PE3.4+
#
define classroom::console::class {
  exec { "add_console_class_${name}":
    path        => '/opt/puppet/bin:/bin',
    cwd         => '/opt/puppet/share/puppet-dashboard',
    environment => 'RAILS_ENV=production',
    command     => "bundle exec rake nodeclass:add['${name}']",
    unless      => "bundle exec rake nodeclass:list | grep ${name}",
  }
}
