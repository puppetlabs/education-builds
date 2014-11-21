node default {
  class { 'staging':
     path  => '/usr/src/installer/',
     owner => 'root',
     group => 'root',
   }
  class { 'bootstrap::get_pe': version => '3.7.0' }
  include epel
  include bootstrap
  include localrepo
  include training
}

node /learn/ {
  class { 'staging':
     path  => '/usr/src/installer/',
     owner => 'root',
     group => 'root',
   }
  class { 'bootstrap::get_pe': version => '3.7.0' }
  include epel
  include bootstrap
  include localrepo
  include learning
  stage { 'pe_install': require => Stage['main'], }
  class { 'learning::install': stage => pe_install, }
  stage { 'post_install': require => Stage['pe_install'],}
  class { 'learning::set_defaults': stage => post_install, }
}
