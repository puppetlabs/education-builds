#!/bin/bash

export PATH=$PATH:/opt/puppetlabs/bin

puppet module install pltraining-classroom --modulepath=/etc/puppetlabs/code/modules

cat << EOF >> /etc/puppetlabs/code/environments/production/manifests/master.pp
node master.puppetlabs.vm {
  include classroom::course::infrastructure
}
EOF

while [ -f /opt/puppetlabs/puppet/cache/state/agent_catalog_run.lock ]; do echo Waiting for Puppet Run to complete; sleep 10; done
while ! curl -k -I https://localhost:8140/packages/ 2>/dev/null | grep "200 OK" > /dev/null; do echo Waiting for Puppet Server to start; sleep 10; done
echo Initializing Puppet Server
sleep 60

puppet agent -t

echo Puppet run completed
