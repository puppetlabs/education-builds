node default {
  class { 'staging':
    path  => '/usr/src/installer/',
    owner => 'root',
    group => 'root',
  }
  class { 'bootstrap::get_pe': version => '3.7.1' }
  class { 'epel': epel_enabled => false }
  include bootstrap
  include localrepo
  include training
}

node /student/ {
  class { 'student': }
}

node /learn/ {
  if $::memorysize_mb <= 4096 {
    class { 'swap_file':
      swapfile     => '/swapfile',
      swapfilesize => '4.0 GB',
    }
    include learning::set_swap
  }

  class { 'staging':
    path  => '/usr/src/installer/',
    owner => 'root',
    group => 'root',
  }
  class { 'bootstrap::get_pe': version => '3.7.1' }
  include epel
  include bootstrap
  include localrepo
  include learning
  include learning::install
  include learning::set_defaults
}
