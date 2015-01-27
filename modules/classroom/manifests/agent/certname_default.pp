class classroom::agent::certname_default (
  $timeout = $classroom::params::timeout,
) inherits classroom::params {

  if $::osfamily == 'windows' {
    ini_setting { 'certname':
      ensure  => present,
      path    => 'C:/ProgramData/PuppetLabs/puppet/etc/puppet.conf',
      section => 'main',
      setting => 'certname',
      value   => "${::hostname}.puppetlabs.vm",
    }
  }
  else {
    fail("The Certname default Class supports only Windows, not ${::osfamily}")
  }

}
