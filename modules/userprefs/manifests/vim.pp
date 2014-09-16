class userprefs::vim (
  $user    = 'root',
  $group   = 'root',
  $homedir = '/root',
  $default = true,
) {
  File {
    owner => $user,
    group => $group,
    mode  => '0644',
  }

  package { 'vim-enhanced':
    ensure => present,
  }

  file { "${homedir}/.vim":
    ensure  => 'directory',
    source  => 'puppet:///modules/userprefs/vim/vim',
    recurse => true,
  }

  file { "${homedir}/.vimrc":
    source => 'puppet:///modules/userprefs/vim/vimrc',
  }

  if $default {
    file_line { 'default editor':
      path    => "${homedir}/.profile",
      line    => 'export EDITOR=vim',
      match   => "EDITOR=",
      require => Package['vim-enhanced'],
    }
  }
}
