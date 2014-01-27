class environment::emacs (
  $default = true,
) {
  package { 'emacs':
    ensure => present,
  }

  file { '/root/.emacs':
    ensure  => 'file',
    source  => 'puppet:///modules/environment/emacs/emacs',
  }

  file { '/root/.emacs.d':
    ensure => directory,
  }

  file { '/root/.emacs.d/puppet-mode.el':
    ensure  => 'file',
    source  => 'puppet:///modules/environment/emacs/puppet-mode.el',
  }

  if $default {
    file_line { 'default editor':
      path    => '/root/.profile',
      line    => 'export EDITOR=emacs',
      match   => "EDITOR=",
      require => Package['emacs'],
    }
  }
}
