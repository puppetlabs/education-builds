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

set -e
set -u

CERT=$(puppet master --configprint hostcert)
CACERT=$(puppet master --configprint localcacert)
PRVKEY=$(puppet master --configprint hostprivkey)
CERT_OPTIONS="--cert ${CERT} --cacert ${CACERT} --key ${PRVKEY}"

MASTER="https://$(hostname):443"

curl -k -X GET -H "Accept: text/yaml" ${CERT_OPTIONS} ${MASTER}/nodes/${1}
