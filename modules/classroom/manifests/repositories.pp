class classroom::repositories (
  $manageyum    = $classroom::params::manageyum,
  $offline      = $classroom::params::offline,
  $repositories = $classroom::params::repositories,
) inherits classroom::params {

  if $manageyum and $::osfamily == 'RedHat' {
    yumrepo { $repositories:
      enabled => $offline ? {
        true  => '0',
        false => '1',
      },
    }
  }

}
