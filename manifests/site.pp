node default {
  include epel
  include bootstrap::role::training
  include localrepo
}

node /student/ {
  include epel
  include bootstrap::role::student
}


node /learn/ {
  include epel
  include bootstrap::role::learning
  include localrepo
  class { 'learning':
    git_branch => 'master'
  }
}

node /puppetfactory/ {
  include epel
  include bootstrap::role::puppetfactory
  include localrepo
}

node /lms/ {
  class { 'lms': }
}
