class extending::capstone (
  $database       = 'drupal',
  $dbuser         = 'drupal',
  $dbpassword     = 'drupal',
  $dbhost         = 'localhost',
  $dbport         = '',
  $dbdriver       = 'mysql',
  $dbprefix       = '',
  $admin_password = 'puppet',
) {

  class { 'extending::capstone::environment':
    
  } ->

  class { 'extending::capstone::requirements':
    database       => $database,
    dbuser         => $dbuser,
    dbpassword     => $dbpassword,
    dbhost         => $dbhost,
  } ->

  class { 'drupal':
    database       => $database,
    dbuser         => $dbuser,
    dbpassword     => $dbpassword,
    dbhost         => $dbhost,
    dbdriver       => $dbdriver,
    admin_password => $admin_password,
  } ->

  class { 'extending::capstone::modules':

  }

}
