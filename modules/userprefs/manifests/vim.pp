class userprefs::vim (
  $default = true,
) {
  package { 'vim-enhanced':
    ensure => present,
  }

  file { '/root/.vim':
    ensure  => 'directory',
    source  => 'puppet:///modules/userprefs/vim/vim',
    recurse => true,
  }

  file { '/root/.vimrc':
    source => 'puppet:///modules/userprefs/vim/vimrc',
  }

  if $default {
    file_line { 'default editor':
      path    => '/root/.profile',
      line    => 'export EDITOR=vim',
      match   => "EDITOR=",
      require => Package['vim-enhanced'],
    }
  }
}
