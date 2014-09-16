class userprefs::profile (
  $user    = 'root',
  $group   = 'root',
  $homedir = '/root',
) {
  File {
    owner => $user,
    group => $group,
    mode  => '0644',
  }

  # Shell aliases that are used by all shells
  file { "${homedir}/.profile":
    ensure  => 'file',
    replace => false, # allow users to customize their .profile
    source  => 'puppet:///modules/userprefs/shell/profile',
  }
}
