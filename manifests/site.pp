node default {
  include bootstrap
  include localrepo
  include training
  include vagrant
}

node /learn/ {
  include bootstrap
  include localrepo
  include learning
  stage { 'pe_install': require => Stage['main'], }
  class { 'learning::install': stage => pe_install, }
}
