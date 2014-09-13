class classroom::virtual::master (
  $extra_repositories = undef,
) inherits classroom::params {

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '1777',
  }

  include git

  user { 'classroom':
    ensure     => present,
    managehome => true,
    password   => $classroom::params::password,
  }

  file { ['/var/repositories', '/etc/puppetlabs/puppet/modules']:
    ensure => directory,
  }

  # Each repository represents a module
  if $extra_repositories {
    $repositories = flatten([$classroom::params::precreated_repositories, $extra_repositories])
  } else {
    $repositories = $classroom::params::precreated_repositories
  }
  classroom::master::repository { $repositories:
    ensure      => present,
    environment => false,
    repo_user   => 'classroom',
    clone_root  => '/etc/puppetlabs/puppet/modules'
  }
}
