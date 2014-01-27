class environment::profile {
  # Shell aliases that are used by all shells
  file { '/root/.profile':
    ensure  => 'file',
    replace => false, # allow users to customize their .profile
    source  => 'puppet:///modules/environment/shell/profile',
  }
}
