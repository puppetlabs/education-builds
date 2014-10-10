# Set up the master with user accounts, environments, etc
class classroom::master (
  $classes     = $classroom::classes,
  $offline     = $classroom::offline,
  $autoteam    = $classroom::autoteam,
  $managerepos = $classroom::managerepos,
) inherits classroom {

  File {
    owner => 'root',
    group => 'root',
    mode  => '1777',
  }

  # This wonkiness is due to the fact that puppet_enterprise::license class
  # manages this file only if it exists on the master. So we do the opposite.
  if ( file('/etc/puppetlabs/license.key', '/dev/null') == undef ) {
    # Write out our edu license file to prevent console noise
    file { '/etc/puppetlabs/license.key':
      ensure => file,
      mode   => '0644',
      source => 'puppet:///modules/classroom/license.key',
    }
  }

  # we know that you all love logging back into the Console every time you do a
  # demo, but we're sadists, so we're goint to take that pleasure away from you.
  file_line { 'rubycas_server_console_session_lifetime':
    ensure => present,
    path   => '/etc/puppetlabs/rubycas-server/config.yml',
    match  => '^maximum_session_lifetime:',
    line   => "maximum_session_lifetime: 100000",
    notify => Service['pe-httpd'],
  }

  file_line { 'console_auth_session_lifetime':
    ensure => present,
    path   => '/etc/puppetlabs/console-auth/cas_client_config.yml',
    match  => '\s*session_lifetime:',
    line   => "  session_lifetime: 100000",
    notify => Service['pe-httpd'],
  }

  # create environments direectory and directory or production environment
  file {['/etc/puppetlabs/puppet/environments','/etc/puppetlabs/puppet/environments/production']:
    ensure => directory,
  }

  # create modules, manifests and config links/files for production environment
  file {'/etc/puppetlabs/puppet/environments/production/modules':
    ensure => link,
    target => '/etc/puppetlabs/puppet/modules',
  }

  file {'/etc/puppetlabs/puppet/environments/production/manifests':
    ensure => link,
    target => '/etc/puppetlabs/puppet/manifests',
  }

  file { "/etc/puppetlabs/puppet/environments/production/environment.conf":
    ensure  => file,
    content => "environment_timeout = 0\n",
    replace => false,
  }

  augeas {'puppet.conf.environmentpath':
    context => "/files/etc/puppetlabs/puppet/puppet.conf/main",
    changes => 'set environmentpath  $confdir/environments',
    require => [
      File['/etc/puppetlabs/puppet/environments/production/modules'],
      File['/etc/puppetlabs/puppet/environments/production/manifests']
    ],
    notify  => Service['pe-httpd'],
  }

  # we need to restart the pe-httpd service when we change puppet.conf
  # it is not under Puppet control in PE, so let's do it here
  service {'pe-httpd':
    ensure => running,
    enable => true,
  }

  # if configured to do so, configure repos & environments on the master
  if $managerepos {
    include classroom::master::repositories
  }

  # Ensure that time is set appropriately
  include classroom::master::time

  # unselect all nodes in Live Management by default
  #include classroom::console::patch

  # Add any classes defined to the console
  classroom::console::class { $classes: }

  # Now create all of the users who've checked in
  Classroom::User <<||>>
}
