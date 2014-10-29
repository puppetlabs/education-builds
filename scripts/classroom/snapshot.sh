#!/bin/bash

CHECKPOINTS="/root/.checkpoints"
TIMESTAMP=`date +%s`

# ensure we've got a place to store data
[ -d "$CHECKPOINTS" ] || mkdir "$CHECKPOINTS"

case $1 in
  ssldir|ssl)
    tar -C / -czf ${CHECKPOINTS}/ssldir-${TIMESTAMP}.tar.gz etc/puppetlabs/puppet/ssl/
    ;;
  submit)
    [[ "`hostname`" =~ ([a-z0-9]+).puppetlabs.vm$ ]]
    username=${BASH_REMATCH[1]}
    scp -r "$CHECKPOINTS" ${username}@master.puppetlabs.vm:checkpoints
    ;;
  *)
    echo "Call this script with the name of the item you wish to snapshot."
    echo "  └─ ssldir (/etc/puppetlabs/puppet/ssl)"
    ;;
esac
