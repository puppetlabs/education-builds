node default {
  include bootstrap
  include localrepo
  include training
  class { 'staging':
     path  => '/usr/src/installer/',
     owner => 'root',
     group => 'root',
   }
  include bootstrap::get_pe
}

node /learn/ {
  include bootstrap
  include localrepo
  include learning
  stage { 'pe_install': require => Stage['main'], }
  class { 'learning::install': stage => pe_install, }
}
