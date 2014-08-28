class userprefs::emacs (
  $user    = 'root',
  $homedir = '/root',
  $default = true,
) {
  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }
  
  package { 'emacs':
    ensure => present,
  }

  file { "${homedir}/.emacs":
    ensure  => 'file',
    source  => 'puppet:///modules/userprefs/emacs/emacs',
  }

  file { "${homedir}/.emacs.d":
    ensure => directory,
  }

  file { "${homedir}/.emacs.d/puppet-mode.el":
    ensure  => 'file',
    source  => 'puppet:///modules/userprefs/emacs/puppet-mode.el',
  }

  if $default {
    file_line { 'default editor':
      path    => "${homedir}/.profile",
      line    => 'export EDITOR=emacs',
      match   => "EDITOR=",
      require => Package['emacs'],
    }
  }
}
