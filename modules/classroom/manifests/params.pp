class classroom::params {
  # Configure NTP (and other services) to run in standalone mode
  $offline   = false

  # Automatically configure environment, etc for students.
  $autosetup = false

  # automatically assign teams for the capstone
  $autoteam  = false

  # list of classes that should be available in the console
  $classes   = [ 'users', 'apache', 'classroom', 'userprefs' ]

  # Name of the student's working directory
  $workdir   = 'puppetcode'

  # Should we manage upstream yum repositories in the classroom?
  $manageyum = true

  # Upstream yum repositories
  $repositories = [ 'base', 'extras', 'updates', 'epel' ]

  # time servers to use if we've got network
  $time_servers = ['0.pool.ntp.org iburst', '1.pool.ntp.org iburst', '2.pool.ntp.org iburst', '3.pool.ntp.org']

  $role = $hostname ? {
    /master|classroom/ => 'master',
    'proxy'            => 'proxy',
    default            => 'agent'
  }

  $download = "\n\nPlease download a new VM: http://downloads.puppetlabs.com/training/\n\n"
  if versioncmp($::classroom_vm_release, '2.5') < 0 {
    fail("Your VM is out of date. ${download}")
  }

  if versioncmp($::pe_version, '3.0.0') < 0 {
    fail("Your Puppet Enterprise installation is out of date. ${download}")
  }
}