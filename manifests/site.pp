node default {
  class { 'staging':
    path  => '/usr/src/installer/',
    owner => 'root',
    group => 'root',
  }
  include epel
  include bootstrap::role::training
  include localrepo
  include training
}

node /student/ {
  include epel
  include bootstrap::role::student
}


node /learn/ {
  class { 'staging':
    path  => '/usr/src/installer/',
    owner => 'root',
    group => 'root',
  }
  include epel
  include bootstrap::role::learning
  include localrepo
  class { 'learning':
    git_branch => 'master'
  }
}

node /puppetfactory/ {
  class { 'staging':
    path  => '/usr/src/installer/',
    owner => 'root',
    group => 'root',
  }
  include epel
  include bootstrap::role::puppetfactory
  include localrepo
}

node /lms/ {
  class { 'lms': }
}
