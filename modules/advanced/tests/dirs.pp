$ssl_certs = [
  '/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-mcollective-servers.pem',
  '/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-mcollective-servers.pem',
  '/etc/puppetlabs/puppet/ssl/certs/pe-internal-mcollective-servers.pem',
  '/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-peadmin-mcollective-client.pem',
  '/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-puppet-console-mcollective-client.pem',
]

$dirs = dirtree(dirnames($ssl_certs))

notify { $dirs: }
