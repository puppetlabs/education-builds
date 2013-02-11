class extending::capstone::modules {

  package { ['drupal7-ctools', 'drupal7-features', 'drupal7-views']:
    ensure  => present,
    notify  => Exec['enable modules'],
  }

  $module_path = '/usr/share/drupal7/sites/all/modules/'
  file { 'puppet_report':
    ensure  => directory,
    path    => "${module_path}/puppet_report",
    source  => 'puppet:///modules/extending/capstone/puppet_report',
    recurse => true,
    notify  => Exec['enable modules'],
  }

  file { 'datasource':
    ensure  => directory,
    path    => "${module_path}/datasource",
    source  => 'puppet:///modules/extending/capstone/datasource',
    recurse => true,
    notify  => Exec['enable modules'],
  }

  file { 'composed_field':
    ensure  => directory,
    path    => "${module_path}/composed_field",
    source  => 'puppet:///modules/extending/capstone/composed_field',
    recurse => true,
    notify  => Exec['enable modules'],
  }

  exec { 'enable modules':
    command     => 'drush pm-enable puppet_report datasource_api -y', # enables dependencies
    path        => '/usr/local/bin:/bin:/usr/bin',
    refreshonly => true,
  }

}