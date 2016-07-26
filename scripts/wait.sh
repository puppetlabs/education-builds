#!/bin/bash

while [ -f /opt/puppetlabs/puppet/cache/state/agent_catalog_run.lock ]; do echo Waiting for Puppet Run to complete; sleep 10; done
while ! curl -k -I https://localhost:8140/packages/ 2>/dev/null | grep "200 OK" > /dev/null; do echo Waiting for Puppet Server to start; sleep 10; done
echo Initializing
sleep 60
