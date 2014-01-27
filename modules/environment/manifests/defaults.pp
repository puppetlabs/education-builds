class environment::defaults {
  include environment::profile

  class { 'environment::bash':  default => false }

  class { 'environment::emacs': default => false }
  class { 'environment::vim':   default => false }
}
