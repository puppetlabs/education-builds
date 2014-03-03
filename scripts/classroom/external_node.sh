#!/bin/bash

set -e
set -u

CERT=$(puppet master --configprint hostcert)
CACERT=$(puppet master --configprint localcacert)
PRVKEY=$(puppet master --configprint hostprivkey)
CERT_OPTIONS="--cert ${CERT} --cacert ${CACERT} --key ${PRVKEY}"

MASTER="https://$(hostname):443"

curl -k -X GET -H "Accept: text/yaml" ${CERT_OPTIONS} ${MASTER}/nodes/${1}
