class userprefs::defaults {
  include userprefs::profile

  class { 'userprefs::bash':  default => false }

  class { 'userprefs::emacs': default => false }
  class { 'userprefs::vim':   default => false }
}
