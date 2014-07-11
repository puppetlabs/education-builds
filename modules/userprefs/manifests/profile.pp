class userprefs::profile (
  $homedir = '/root',
) {
  # Shell aliases that are used by all shells
  file { "${homedir}/.profile":
    ensure  => 'file',
    replace => false, # allow users to customize their .profile
    source  => 'puppet:///modules/userprefs/shell/profile',
  }
}
