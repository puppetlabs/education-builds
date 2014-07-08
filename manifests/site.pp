node default {
  include bootstrap
  include localrepo
  include training
}

node /learn/ {
  include bootstrap
  include localrepo
  include vagrant
  include learning
  stage { 'pe_install': require => Stage['main'], }
  class { 'learning::install': stage => pe_install, }
}
