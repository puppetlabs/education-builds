class fundamentals::environment::vim {
  package { 'vim-enhanced':
    ensure => present,
  }

  file { '/root/.vim':
    ensure  => 'directory',
    source  => 'puppet:///modules/fundamentals/environment/vim/vim',
    recurse => true,
  }

  file { '/root/.vimrc':
    source => 'puppet:///modules/fundamentals/environment/vim/vimrc',
  }

  file_line { 'default editor':
    path    => '/root/.bash_profile',
    line    => 'export EDITOR=vim',
    match   => "EDITOR=",
    require => Package['vim-enhanced'],
  }
}
