# Add a user to a team.
# Membership in a team is simply defined by that user's ssh key
# being present in the team user's authorized_keys
#
# $name: colon delimited list of $team:$user
#
define classroom::master::team::membership {
  $args = split($name, ':')
  $team = $args[0]
  $user = $args[1]
  
  exec { "team membership ${name}":
    unless  => "grep ${user} ~${team}/.ssh/authorized_keys",
    command => "grep ${user} ~${user}/.ssh/authorized_keys >> ~${team}/.ssh/authorized_keys",
    path    => '/usr/bin:/bin',
  }
  
}
