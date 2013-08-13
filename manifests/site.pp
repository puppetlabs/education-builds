node default {
  include bootstrap
  include localrepo
  include training
  include vagrant
}

node /learn/ {
  class { 'bootstrap': print_console_login => true, }
  include localrepo
  include learning
  stage { 'pe_install': require => Stage['main'], }
  class { 'learning::install': stage => pe_install, }
}
