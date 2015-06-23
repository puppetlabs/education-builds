node default {
  class { 'staging':
    path  => '/usr/src/installer/',
    owner => 'root',
    group => 'root',
  }
  class { 'bootstrap::get_pe': 
    version => '3.8.1'
  }
  class { 'bootstrap::get_32bit_agent': 
    version => '3.8.1' 
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
    version => '3.8.1' 
  }
  include epel
  include bootstrap
  include localrepo
  class { 'learning':
    git_branch => 'master'
  }
  include bootstrap::install_pe
  include bootstrap::set_defaults
}

node /puppetfactory/ {
  class { 'staging':
    path  => '/usr/src/installer/',
    owner => 'root',
    group => 'root',
  }
  class { 'bootstrap::get_pe': 
    version => '3.8.1' 
  }  
  class { 'bootstrap::install_pe':}
  include epel
  include bootstrap
  include localrepo
  include lms::labdeps
}

node /lms/ {
  class { 'lms': }
}
