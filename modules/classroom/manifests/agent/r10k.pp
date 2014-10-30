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
    purgedirs => [ $basedir ],
    version   => '1.3.4',
  }
}
