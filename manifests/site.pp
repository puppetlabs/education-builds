$pe_version = '2.5.2'
node default {
  include bootstrap
  include pebase

  include localrepo
  include training
}

node /learn/ {
  include bootstrap
  include pebase

  include learning
  stage { 'pe_install': require => Stage['main'], }
  class { 'learning::install': stage => pe_install, }
}
