# creates a user in the console
#
define classroom::console::user ( $password ) {
  # Rake tasks to create and list users
  $command   = 'bundle exec rake -f /opt/puppet/share/console-auth/Rakefile db:create_user '
  $userlist  = 'bundle exec rake -f /opt/puppet/share/console-auth/Rakefile db:users:list'

  exec { "add_console_user_${name}":
    path        => '/opt/puppet/bin:/usr/bin:/bin',
    cwd         => '/opt/puppet/share/puppet-dashboard',
    environment => 'RAILS_ENV=production',
    command     => "${command} USERNAME=${name}@puppetlabs.com PASSWORD=${password} ROLE=Read-Write",
    unless      => "${userlist} | grep ${name}"
  }
}
