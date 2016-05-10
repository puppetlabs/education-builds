#!/bin/bash

export PATH=$PATH:/opt/puppetlabs/bin

puppet module install pltraining-selfpaced --modulepath=/etc/puppetlabs/code/modules

cat << COMMON >> /etc/puppetlabs/code/environments/production/hieradata/common.yaml
---
puppet_enterprise::profile::console::console_ssl_listen_port: 8443
COMMON

echo "autosign = true" >> /etc/puppetlabs/puppet/puppet.conf

cat << SITE >> /etc/puppetlabs/code/environments/production/manifests/site.pp
node master.puppetlabs.vm {
  include selfpaced
}
SITE

while [ -f /opt/puppetlabs/puppet/cache/state/agent_catalog_run.lock ]; do echo Waiting for Puppet Run to complete; sleep 10; done
while ! curl -k -I https://localhost:8140/packages/ 2>/dev/null | grep "200 OK" > /dev/null; do echo Waiting for Puppet Server to start; sleep 10; done
echo Initializing Puppet Server
sleep 60

puppet agent -t

echo Puppet run completed
