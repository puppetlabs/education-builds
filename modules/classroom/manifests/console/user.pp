# creates a user in the console
#
# Make this rake business go away when we don't have to support PE <= 3.3
#
define classroom::console::user ( $password, $role = 'Operator' ) {
  # Rake tasks to create and list users
  $command   = 'bundle exec rake -f /opt/puppet/share/console-auth/Rakefile db:create_user '
  $userlist  = 'bundle exec rake -f /opt/puppet/share/console-auth/Rakefile db:users:list'

  if versioncmp($::pe_version, '3.4.0') >= 0 {
    $roleid = downcase($role) ? {
      /administrators?/ => 1,
      /operators?/      => 2,
      default           => 3,
    }
    $arguments = "LOGIN=${name} EMAIL=${name}@puppetlabs.com DISPLAYNAME=${name} ROLEIDS=${roleid}"
  }
  else {
    $permission = downcase($role) ? {
      /administrators?/ => 'Admin',
      /operators?/      => 'Read-Write',
      default           => 'Read-Only',
    }
    $arguments = "USERNAME=${name}@puppetlabs.com PASSWORD=${password} ROLE=${permission}"
  }

  exec { "add_console_user_${name}":
    path        => '/opt/puppet/bin:/usr/bin:/bin',
    cwd         => '/opt/puppet/share/puppet-dashboard',
    environment => 'RAILS_ENV=production',
    command     => "${command} ${arguments}",
    unless      => "${userlist} | grep ${name}",
  }
}
