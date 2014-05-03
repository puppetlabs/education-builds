class classroom::params {
  # Configure NTP (and other services) to run in standalone mode
  $offline   = false

  # Automatically configure environment, etc for students.
  $autosetup = false

  # automatically assign teams for the capstone
  $autoteam  = false

  # list of classes that should be available in the console
  $classes   = [ 'users', 'apache', 'classroom' ]

  # Name of the student's working directory
  $workdir   = 'puppetcode'

  # Should we manage upstream yum repositories in the classroom?
  $manageyum = true

  # Upstream yum repositories
  $repositories = [ 'base', 'extras', 'updates', 'epel' ]

  $role = $hostname ? {
    'master' => 'master',
    default  => 'agent'
  }

  if versioncmp($::classroom_vm_release, '2.5') < 0 {
    fail('Your VM is out of date: http://downloads.puppetlabs.com/training/')
  }

  if versioncmp($::pe_version, '3.0.0') < 0 {
    fail('Your Puppet Enterprise installation is out of date. Please download a new VM: http://downloads.puppetlabs.com/training/')
  }
}