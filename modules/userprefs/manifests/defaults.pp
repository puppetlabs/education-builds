class userprefs::defaults {
  include userprefs::profile

  class { 'userprefs::bash':
    password => '$1$hgIZHl1r$tEqMTzoXz.NBwtW3kFv33/'
    replace  => true,
  }

  class { 'userprefs::emacs': default => false }
  class { 'userprefs::vim':   default => false }
}
