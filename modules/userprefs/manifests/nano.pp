class userprefs::nano (
  $user    = 'root',
  $homedir = '/root',
  $default = true,
) {
  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }
  
  package { 'nano':
    ensure => present,
  }

  file { "${homedir}/.nanorc":
    ensure  => 'file',
    source  => 'puppet:///modules/userprefs/nano/nanorc',
  }

  file { "${homedir}/.nano.d":
    ensure => directory,
  }

  file { "${homedir}/.nano.d/puppet.nanorc":
    ensure  => 'file',
    source  => 'puppet:///modules/userprefs/nano/puppet.nanorc',
  }

  if $default {
    file_line { 'default editor':
      path    => "${homedir}/.profile",
      line    => 'export EDITOR=nano',
      match   => "EDITOR=",
      require => Package['nano'],
    }
  }
}
