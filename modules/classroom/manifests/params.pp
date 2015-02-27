class classroom::params {
  # Configure NTP (and other services) to run in standalone mode
  $offline   = false

  # Automatically configure environment, etc for students.
  $autosetup = false

  # automatically assign teams for the capstone
  $autoteam  = false

  # list of classes that should be available in the console
  $classes   = [ 'users', 'apache', 'userprefs' ]

  if $::osfamily == 'windows' {
    # Path to the student's working directory
    $workdir = 'c:/puppetcode'
    $etcpath = 'C:/ProgramData/PuppetLabs/puppet/etc'
  }
  else {
    $workdir = '/root/puppetcode'
    $etcpath = '/etc/puppetlabs/puppet'
  }

  # default user password
  $password  = '$1$Tge1IxzI$kyx2gPUvWmXwrCQrac8/m0' # puppetlabs
  $consolepw = 'puppetlabs'

  # Should we manage upstream yum repositories in the classroom?
  $manageyum = true

  # Upstream yum repositories
  $repositories = [ 'base', 'extras', 'updates' ]

  # manage git repositories for the student and the master
  $managerepos = true

  # time servers to use if we've got network
  $time_servers = ['0.pool.ntp.org iburst', '1.pool.ntp.org iburst', '2.pool.ntp.org iburst', '3.pool.ntp.org']

  # where the agent installer tarball should go. This is only relevant when promoting a secondary master
  $publicdir = '/opt/puppet/packages/public/classroom'

  # The directory where the VM caches stuff locally
  $cachedir = '/usr/src/installer'

  # Default timeout for operations requiring downloads or the like
  $timeout = 600

  # list of module repositorites that should be precreated for the virtual courses
  $precreated_repositories = [ 'critical_policy', 'registry', 'profiles' ]
  
  # Windows active directory setup parameters
  $ad_domainname           = 'CLASSROOM.local'
  $ad_netbiosdomainname    = 'CLASSROOM'
  $ad_dsrmpassword         = 'Puppetlabs1'

  # Certname and machine name from cert
  if is_domain_name("${::clientcert}") {
    $full_machine_name = split($::clientcert,'[.]')
    $machine_name = $full_machine_name[0]
  }
  else {
    $machine_name = $::clientcert
  }
  
  # is this a student's tier3 agent in Architect?
  if $fqdn =~ /^\S+\.\S+\.puppetlabs\.vm$/ {
    $role = 'tier3'
  }
  else {
    $role = $hostname ? {
      /^master|classroom$/ => 'master',
      'proxy'            => 'proxy',
      default            => 'agent'
    }
  }

  $download = "\n\nPlease download a new VM: http://downloads.puppetlabs.com/training/\n\n"
  if $::classroom_vm_release and versioncmp($::classroom_vm_release, '2.11') < 0 {
    fail("Your VM is out of date. ${download}")
  }

  if versioncmp($::pe_version, '3.3.0') < 0 {
    fail("Your Puppet Enterprise installation is out of date. ${download}")

  }

}
