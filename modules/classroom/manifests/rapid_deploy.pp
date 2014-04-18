# Configure the classroom environment for Rapid Deployment.
#
# This class is designed to work with the pre-baked gitlab virtual machine.
#
# classroom::rapid_deploy
#   * Configure host entry for gitlab server
#   * Configure r10k and remove extra environments from previous classes
#   * Set up the deploy webhook gitlab will be calling
#   * Configure git and SSH keys
#
# $gitserver    : Hostname of gitlab server.
# $gitserver_ip : IP address of gitlab server (required).
#
class classroom::rapid_deploy (
  $gitserver = 'gitlabs.puppetlabs.vm',
  $gitserver_ip,
) {
  if ! is_ip_address($gitserver_ip) {
    fail('Please pass a valid IP address to the rapid_deploy class')
  }

  File {
    owner => 'root',
    group => 'root',
    mode  => '0755',
  }

  host { $gitserver:
    ip => $gitserver_ip,
  }

  class { 'r10k':
    sources => {
      'puppet' => {
        'remote'  => "git@${gitserver}:root/control.git",
        'basedir' => "${::settings::confdir}/environments",
        'prefix'  => false,
      }
    },
    purgedirs         => ["${::settings::confdir}/environments"],
    manage_modulepath => true,
    modulepath        => "${::settings::confdir}/environments/\$environment/modules:/etc/puppetlabs/puppet/modules:/opt/puppet/share/puppet/modules",
  }

  augeas { 'purge extra environments':
    context => '/files/etc/puppetlabs/puppet/puppet.conf',
    changes => "rm *[label() != 'main' and label() != 'agent' and label() != 'master']",
  }

  file { '/etc/init.d/webhooks':
    ensure => file,
    source => 'puppet:///modules/classroom/webhooks.init',
    before => Service['webhooks'],
  }

  file { '/usr/local/bin/webhooks':
    ensure  => file,
    content => template('classroom/webhooks.erb'),
    notify  => Service['webhooks'],
  }

  package { 'sinatra':
    ensure   => present,
    provider => gem,
    before   => Service['webhooks'],
  }

  service { 'webhooks':
    ensure => running,
    enable => true,
  }

  file { '/root/.ssh':
    ensure => directory,
    mode   => '0600',
  }
  file { '/root/.ssh/config':
    ensure => file,
    mode   => '0600',
    source => 'puppet:///modules/classroom/gitlab/sshconfig',
  }
  file { '/root/.ssh/gitlab_rsa':
    ensure => file,
    mode   => '0600',
    source => 'puppet:///modules/classroom/gitlab/gitlab_rsa',
  }
  file { '/root/.ssh/gitlab_rsa.pub':
    ensure => file,
    mode   => '0600',
    source => 'puppet:///modules/classroom/gitlab/gitlab_rsa.pub',
  }
  file { '/root/.gitconfig':
    ensure => file,
    mode   => '0644',
    source => 'puppet:///modules/classroom/gitlab/gitconfig',
  }
}