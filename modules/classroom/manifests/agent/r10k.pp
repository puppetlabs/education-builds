class classroom::agent::r10k (
  $remote  = '/root/environments',
  $basedir = "${::settings::confdir}/environments",
) {
  class { '::r10k':
    sources => {
      'puppet' => {
        'remote'  => $remote,
        'basedir' => $basedir,
        'prefix'  => false,
      }
    },
    purgedirs         => [ $basedir ],
    manage_modulepath => true,
    modulepath        => "${basedir}/\$environment/modules:/etc/puppetlabs/puppet/modules:/opt/puppet/share/puppet/modules",
  }
}

