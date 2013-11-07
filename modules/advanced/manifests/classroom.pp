# Main class applied to classroom
class advanced::classroom {
  include kickstand
  include advanced::irc::client
  include advanced::classroom::puppetdb
  include advanced::mcollective::master

  # console fixes for Safari
  include advanced::classroom::console

  # This wonkiness is due to the fact that puppet_enterprise::license class
  # manages this file only if it exists on the master. So we do the opposite.
  if ( file('/etc/puppetlabs/license.key', '/dev/null') == undef ) {
    # Write out our edu license file to prevent console noise
    file { '/etc/puppetlabs/license.key':
      ensure => file,
      source => 'puppet:///modules/advanced/license.key',
    }
  }

  package { 'rubygem-sinatra':
    ensure   => present,
    before   => Class['kickstand'],
  }
}
