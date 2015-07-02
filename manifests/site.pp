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
  include localrepo
  include bootstrap::role::learning
}

node /puppetfactory/ {
  include epel
  include bootstrap::role::puppetfactory
  include localrepo
}

node /lms/ {
  class { 'lms': }
}
