# Set up the master with user accounts, environments, etc
class classroom::master (
  $classes     = $classroom::classes,
  $offline     = $classroom::offline,
  $autoteam    = $classroom::autoteam,
  $managerepos = $classroom::managerepos,
) inherits classroom {

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # This wonkiness is due to the fact that puppet_enterprise::license class
  # manages this file only if it exists on the master. So we do the opposite.
  if ( file('/etc/puppetlabs/license.key', '/dev/null') == undef ) {
    # Write out our edu license file to prevent console noise
    file { '/etc/puppetlabs/license.key':
      ensure => file,
      source => 'puppet:///modules/classroom/license.key',
    }
  }

  # we know that you all love logging back into the Console every time you do a
  # demo, but we're sadists, so we're going to take that pleasure away from you.
  if versioncmp($::pe_version, '3.7.0') > 0 {
    classroom::console::groupparam { 'session timeout':
      group     => 'PE Console',
      classname => 'puppet_enterprise::profile::console',
      parameter => 'rbac_session_timeout',
      value     => '4320',
    }
  }
  elsif versioncmp($::pe_version, '3.4.0') >= 0 {
    file { '/etc/puppetlabs/console-services/conf.d/rbac-session.conf':
      ensure => file,
      source => 'puppet:///modules/classroom/rbac-session.conf',
    }
  }
  else {
    file_line { 'rubycas_server_console_session_lifetime':
      ensure => present,
      path   => '/etc/puppetlabs/rubycas-server/config.yml',
      match  => '^maximum_session_lifetime:',
      line   => "maximum_session_lifetime: 1000000",
      notify => Service['pe-httpd'],
    }

    file_line { 'console_auth_session_lifetime':
      ensure => present,
      path   => '/etc/puppetlabs/console-auth/cas_client_config.yml',
      match  => '\s*session_lifetime:',
      line   => "  session_lifetime: 1000000",
      notify => Service['pe-httpd'],
    }
  }

  # https://docs.puppetlabs.com/puppet/latest/reference/environments_configuring.html#environmenttimeout
  # Suggests that this setting can be pushed up to puppet.conf globally.
  # Initial testing appears to confirm that. If this proves problematic, then
  # uncomment this resource and the relevant resource in classroom::agent::workdir
  # file { "/etc/puppetlabs/puppet/environments/production/environment.conf":
  #   ensure  => file,
  #   content => "environment_timeout = 0\n",
  #   replace => false,
  # }

  # Ensure the environment cache is disabled and restart if needed
  ini_setting {'environment timeout':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'main',
    setting => 'environment_timeout',
    value   => '0',
  }

  # Anything that needs to be top scope
  file { '/etc/puppetlabs/puppet/environments/production/manifests/classroom.pp':
    ensure => file,
    source => 'puppet:///modules/classroom/classroom.pp',
  }

  # if configured to do so, configure repos & environments on the master
  if $managerepos {
    File <| title == '/etc/puppetlabs/puppet/environments' |> {
      mode => '1777',
    }

    include classroom::master::repositories
  }

  # Ensure that time is set appropriately
  include classroom::master::time

  # unselect all nodes in Live Management by default
  #include classroom::console::patch

  # Now create all of the users who've checked in
  Classroom::User <<||>>

  # Remainder of manifest is manual fiddling not needed on current PE
  if versioncmp($::pe_version, '3.4.0') < 0 {
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

    ini_setting { 'puppet.conf.environmentpath':
      ensure  => present,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'main',
      setting => 'environmentpath',
      value   => '$confdir/environments',
      notify  => Service['pe-httpd'],
    }

    # we need to restart the pe-httpd service when we change puppet.conf
    # it is not under Puppet control in PE, so let's do it here
    service {'pe-httpd':
      ensure => running,
      enable => true,
    }

    # Add any classes defined to the console
    classroom::console::class { $classes: }
  }
}
