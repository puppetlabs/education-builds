# Main proxy configuration, commented lines see readme
class advanced::proxy {

  # The .deb stuff is temp before a refactor of vm
  class {'advanced::proxy::hostname':} ->
  class {'advanced::proxy::haproxy':} ->
  #file { 'puppetlabs-enterprise-release-extras.deb':
  #  ensure => file,
  #  path   => '/tmp/puppetlabs-enterprise-release-extras.deb',
  #  source => "puppet:///${module_name}/puppetlabs-enterprise-release-extras.deb",
  #} ->
  #package { '/tmp/puppetlabs-enterprise-release-extras.deb':
  #  ensure   => present,
  #  provider => 'dpkg',
  #  source   => '/tmp/puppetlabs-enterprise-release-extras.deb',
  #} ->
  class {'advanced::irc::server':}


}
