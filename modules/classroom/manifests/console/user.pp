# creates a user in the PE Console
#
define classroom::console::user ( $password, $role = 'Operators' ) {

  if versioncmp($::pe_version, '3.4.0') >= 0 {
    rbac_user { $name:
      ensure       => present,
      password     => $password,
      display_name => $name,
      email        => "${name}@puppetlabs.vm",
      roles        => $role,
    }
  }
  else {
    # Here there be dragons.

    $permission = downcase($role) ? {
      /administrators?/ => 'Admin',
      /operators?/      => 'Read-Write',
      default           => 'Read-Only',
    }
    # Rake tasks to create and list users
    $command   = 'bundle exec rake -f /opt/puppet/share/console-auth/Rakefile db:create_user '
    $userlist  = 'bundle exec rake -f /opt/puppet/share/console-auth/Rakefile db:users:list'
    $arguments = "USERNAME=${name}@puppetlabs.vm PASSWORD=${password} ROLE=${permission}"
    $unless    = "${userlist} | grep ',${name}@puppetlabs.vm,'"

    exec { "add_console_user_${name}":
      path        => '/opt/puppet/bin:/usr/bin:/bin',
      cwd         => '/opt/puppet/share/puppet-dashboard',
      environment => 'RAILS_ENV=production',
      command     => "${command} ${arguments}",
      unless      => $unless,
    }
  }
}
