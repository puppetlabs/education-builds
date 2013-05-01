# This will create the group user and repository
# and copy in the ssh keys to enable access to all members
define fundamentals::master::team ($teams) {
  # This allows students to belong to multiple teams. I'm
  # not exactly sure what the use case for this is, but if
  # I don't allow it then surely a student will find one.
  $members = prefix($teams[$name], "$name:")

  fundamentals::user { $name:
    password         => '!!',
    console_password => undef,
  }

  # set each user's membership in this team
  # We can't just use exported ssh keys because we may need multiple instantiations.
  fundamentals::master::team::membership { $members:
    require => Fundamentals::User[$name]
  }
}