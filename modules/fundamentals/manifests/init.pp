class fundamentals {

  include concat::setup

  # Convert facter strings to booleans
  $is_puppetmaster = $::fact_is_puppetmaster ? { 'true'  => true, 'false' => false }
  $is_puppetca = $::fact_is_puppetca ? { 'true'  => true, 'false' => false }
  $is_puppetconsole = $::fact_is_puppetconsole ? { 'true'  => true, 'false' => false }
  $is_puppetagent = $::fact_is_puppetagent ? { 'true'  => true, 'false' => false }


  if $is_puppetmaster {

    concat{ 'puppet_conf_concat':
      name  => '/etc/puppetlabs/puppet/puppet.conf',
      owner => 'pe-puppet',
      group => 'pe-puppet',
      mode  => '0644',
    }

    concat::fragment{ 'puppet_conf':
      target  => '/etc/puppetlabs/puppet/puppet.conf',
      source  => '/root/puppet.conf',
      order   => 01,
    }

    exec { 'cp_puppet_conf':
      command => '/bin/cp /etc/puppetlabs/puppet/puppet.conf /root/puppet.conf',
      unless  => '/usr/bin/test -f /root/puppet.conf',
      before  => Concat::Fragment['puppet_conf'],
    }

    $student_array = split($::students, ',')
    fundamentals::user { $student_array: }

    $class_array = split($::classes, ',')
    fundamentals::console_class { $class_array: }
  }

  if $is_puppetagent and ! $is_puppetmaster {

    # Establish the mount point for sshfs/nfs
    file { '/root/master_home':
      ensure => directory,
    }
    # Configure the NFS Mount
    # Updated to skip our ubuntu demo boxen
    case $::osfamily {
      'RedHat': {
        $configure_nfs = true
      }
      'Debian': {
        $configure_nfs = false 
      }
    }
    if $configure_nfs {
      include fundamentals::nfs::client
    }
    # A little hack to make the remote mount behave as
    # part of the users local modulepath, useful for apply
    file { '/etc/puppetlabs/puppet/modules':
      ensure => 'symlink',
      target => '/root/master_home/modules',
    }
    # /etc/puppet/ssl is confusing to have around. Sloppy. Kill.
    file {'/etc/puppet':
      ensure  => absent,
      recurse => true,
      force   => true,
    }

  }

}
