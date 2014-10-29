#!/bin/bash
#
# This script will force a refresh of the classes available to use in the
# PE Node Classifier. This enables us to classify immediately, rather than
# waiting for the cache to expire.
#
# refresh_classes.sh
#

if [ "$#" -ne 0 ]
then
  echo "This script takes no arguments."
  exit 1
fi

function refresh()
{
  set -e
  set -u

  CERT=$(puppet master --configprint hostcert)
  CACERT=$(puppet master --configprint localcacert)
  PRVKEY=$(puppet master --configprint hostprivkey)
  OPTIONS="--cert ${CERT} --cacert ${CACERT} --key ${PRVKEY}"
  CONSOLE=$(awk '/server =/{print $NF}' /etc/puppetlabs/puppet/console.conf)

  curl -k -X POST ${OPTIONS} "https://${CONSOLE}:4433/classifier-api/v1/update-classes"
}

# only run one copy at a time
for pid in $(pidof -x $(basename $0)); do
  [ $pid != $$ ] && exit 1
done

refresh &
