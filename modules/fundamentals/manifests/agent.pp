# This class configures the agent with
#  * root sshkey
#  * git source repository
#  * git pre-commit hook
class fundamentals::agent ( $workdir = '/root/puppetcode' ) {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }
  Exec {
    path => '/usr/bin:/bin:/user/sbin:/usr/sbin',
  }

  package { 'git':
    ensure => present,
  }

  file { '/root/.ssh':
    ensure => directory,
    mode   => '0600',
  }

  exec { 'generate_key':
    command => 'ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa',
    creates => '/root/.ssh/id_rsa',
    require => File['/root/.ssh'],
  }

  file { [ $workdir, "${workdir}/modules" ]:
    ensure => directory,
  }

  file { "${workdir}/site.pp":
    ensure  => file,
    source  => 'puppet:///modules/fundamentals/site.pp',
    replace => false,
  }

  # create a symlink to allow local puppet use
  file { '/etc/puppetlabs/puppet/modules':
    ensure => link,
    target => "${workdir}/modules",
    force  => true,
  }

  exec { "git config --global user.name '${::hostname}'":
    unless  => 'git config --global user.name',
    require => Package['git'],
  }

  exec { "git config --global user.email ${::hostname}@puppetlabs.vm":
    unless  => 'git config --global user.email',
    require => Package['git'],
  }

  # Can't use vcsrepo because we cannot clone.
  exec { 'initialize git repo':
    command   => "git init ${workdir}",
    creates   => "${workdir}/.git",
    require   => File[$workdir],
  }

  exec { 'add git remote':
    unless  => "git --git-dir ${workdir}/.git config remote.origin.url",
    command => "git --git-dir ${workdir}/.git remote add origin ${::hostname}@master.puppetlabs.vm:/var/repositories/${hostname}.git",
    require => Exec['initialize git repo'],
  }

  file { "${workdir}/.git/hooks/pre-commit":
    ensure  => file,
    source  => 'puppet:///modules/fundamentals/pre-commit',
    mode    => '0755',
    require => Exec['initialize git repo'],
  }

  # /etc/puppet/ssl is confusing to have around. Sloppy. Kill.
  file {'/etc/puppet':
    ensure  => absent,
    recurse => true,
    force   => true,
  }

  # export a fundamentals::user with our ssh key.
  #
  # !!!! THIS WILL EXPORT AN EMPTY KEY ON THE FIRST RUN !!!!
  #
  # On the second run, the ssh key will exist and so this fact will be set.
  @@fundamentals::user { $::hostname:
    key  => $::root_ssh_key,
  }
}

