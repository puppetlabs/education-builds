# Make sure that Hiera is configured for all nodes so that we
# can work through the hiera sections without teaching them
# how to configure it.
class fundamentals::hiera {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { '/etc/puppetlabs/puppet/hieradata':
    ensure => directory,
  }

  file_line { 'hiera_datadir':
    path  => '/etc/puppetlabs/puppet/hiera.yaml',
    match => '^\s{2}:datadir:',
    line  => '  :datadir: /etc/puppetlabs/puppet/hieradata',
  }

  file { '/etc/puppetlabs/puppet/hieradata/global.yaml':
    ensure  => file,
    source  => 'puppet:///modules/fundamentals/global.yaml',
    replace => false,
  }
}
