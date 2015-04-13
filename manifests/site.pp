node default {
  class { 'staging':
    path  => '/usr/src/installer/',
    owner => 'root',
    group => 'root',
  }
  class { 'bootstrap::get_pe': 
    version => '3.7.2' 
  }
  class { 'bootstrap::get_32bit_agent': 
    version => '3.7.2' 
  }
  include epel
  include bootstrap
  include localrepo
  include training
}

node /student/ {
  include epel
  class { 'student': } 
}

node /learn/ {
  class { 'staging':
    path  => '/usr/src/installer/',
    owner => 'root',
    group => 'root',
  }
  class { 'bootstrap::get_pe': 
    version => '3.7.2' 
  }
  include epel
  include bootstrap
  include localrepo
  include learning
  include learning::install
  include learning::set_defaults
}

node /lms/ {
  include epel
  include localrepo
  class { 'lms': }
}
