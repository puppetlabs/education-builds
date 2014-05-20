# Manage yum (and maybe someday apt) repositories in the classroom.
class classroom::repositories (
  $manageyum    = $classroom::manageyum,
  $offline      = $classroom::offline,
  $repositories = $classroom::repositories,
) inherits classroom {

  if $manageyum and $::osfamily == 'RedHat' {
    yumrepo { $repositories:
      enabled => $offline ? {
        true  => '0',
        false => '1',
      },
    }
  }

}
