class fundamentals::environment::emacs {
  package { 'emacs':
    ensure => present,
  }

  file { '/root/.emacs':
    ensure  => 'file',
    source  => 'puppet:///modules/fundamentals/environment/emacs/emacs',
  }

  file { '/root/.emacs.d':
    ensure => directory,
  }

  file { '/root/.emacs.d/puppet-mode.el':
    ensure  => 'file',
    source  => 'puppet:///modules/fundamentals/environment/emacs/puppet-mode.el',
  }

  file_line { 'default editor':
    path    => '/root/.bash_profile',
    line    => 'export EDITOR=emacs',
    match   => "EDITOR=",
    require => Package['emacs'],
  }
}
