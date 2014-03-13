#!/bin/bash
#
# The /nodes endpoint is now authenticated, and has an actual terminus.
# As such, the external_nodes script was deprecated. It was, however,
# useful for debugging, and for teaching how the node classifier works.
#
# This is a simple reimplementation that calls the actual endpoint for
# manual debugging. It will just show you the yaml representation of the
# node's classification. It should be called just like the old script.
#
# external_node.sh <node name>
#

if [ "$#" -ne 1 ]
then
  echo "Please call this script with the name of a node."
  echo "  example usage: external_node.sh <node name>"
  exit 1
fi

set -e
set -u

CERT=$(puppet master --configprint hostcert)
CACERT=$(puppet master --configprint localcacert)
PRVKEY=$(puppet master --configprint hostprivkey)
CERT_OPTIONS="--cert ${CERT} --cacert ${CACERT} --key ${PRVKEY}"
CONSOLE=$(awk '/server =/{print $NF}' /etc/puppetlabs/puppet/console.conf)
MASTER="https://${CONSOLE}:443"

curl -k -X GET -H "Accept: text/yaml" ${CERT_OPTIONS} "${MASTER}/nodes/${1}"

