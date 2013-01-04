class bootstrap::cache_modules(
  $cache_dir = '/usr/src/forge',
) {
  Bootstrap::Forge {
    cache_dir => $cache_dir,
  }

  file { $cache_dir:
    ensure => directory,
  }

  # These are the modules needed by the Fundamentals course

  bootstrap::forge { 'saz-sudo': }
  bootstrap::forge { 'jonhadfield-wordpress': }
  bootstrap::forge { 'puppetlabs-firewall': }
  bootstrap::forge { 'puppetlabs-mysql': }

  # These are the modules needed by the Advanced course

  # These are the modules needed by the extending puppet using ruby course
}
