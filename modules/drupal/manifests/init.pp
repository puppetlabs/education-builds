class drupal (
  $database       = 'drupal',
  $dbuser         = 'drupal',
  $dbpassword     = 'drupal',
  $dbhost         = 'localhost',
  $dbport         = '',
  $dbdriver       = 'mysql',
  $dbprefix       = '',
  $admin_password,
) {
  include drupal::drush

  package { 'drupal7':
    ensure => present,
    notify => Exec['install default drupal site'],
  }

  file { '/usr/share/drupal7/.htaccess':
    ensure  => file,
    source  => 'puppet:///modules/drupal/htaccess',
    require => Package['drupal7'],
  }

  file { 'settings.php':
    ensure  => file,
    path    => '/usr/share/drupal7/sites/default/settings.php',
    content => template('drupal/settings.php.erb'),
    require => Package['drupal7'],
  }

  exec { 'install default drupal site':
    command => 'drush site-install standard -y',
    path    => '/usr/local/bin:/bin:/usr/bin',
    unless  => 'drush core-status | grep "bootstrap.*Successful"',
    require => [ Class['drupal::drush'], File['settings.php'] ],
    notify  => Exec['set default drupal admin password'];
  }

  exec { 'set default drupal admin password':
    command     => "drush user-password admin --password=${admin_password}",
    path        => '/usr/local/bin:/bin:/usr/bin',
    refreshonly => true,
    require     => Exec['install default drupal site'],
  }

}
