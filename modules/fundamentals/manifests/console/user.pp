# creates a user in the console
#
# Uses a nasty hack to determine idempotency that assumes that homedir 
# creation indicates console existance. This is icky. Fix soon.
define fundamentals::console::user ( $password ) {

  # work around a gratuitous API change in PE 2.6
  if versioncmp($::fundamentals_pe_version, '2.6') < 0 {
    $userstring = 'EMAIL'
  } else {
    $userstring = 'USERNAME'
  }

  # Working around how rake tasks use bundle post 3.0.0

  if versioncmp($::fundamentals_pe_version, '3.0.0') < 0 {
    $execute_me = 'rake db:create_user '
    $current_dir = '/opt/puppet/share/console-auth'
   } else {
    $execute_me = 'bundle exec rake -f /opt/puppet/share/console-auth/Rakefile db:create_user '
    $current_dir = '/opt/puppet/share/puppet-dashboard'
   }

  exec { "add_console_user_${name}":
    path        => '/opt/puppet/bin:/usr/bin',
    cwd         => $current_dir,
    environment => 'RAILS_ENV=production',
    command     => "${execute_me} ${userstring}=${name}@puppetlabs.com PASSWORD=${password} ROLE=Read-Write",
    unless      => "test -d /home/${name}",
    before      => File["/home/${name}"],
  }

}
