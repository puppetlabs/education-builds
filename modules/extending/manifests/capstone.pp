class extending::capstone {

  class { 'extending::capstone::requirements':

  } ->

  class { 'drupal':

  } ->

  class { 'extending::capstone::modules':

  }

}
