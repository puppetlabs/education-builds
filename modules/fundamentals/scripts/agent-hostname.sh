#!/bin/bash

export FACTER_SET_HOST_NAME="$1"

if [ ${#FACTER_SET_HOST_NAME} -eq 0 ] ; then
    echo "Usage:"
    echo "$0 <yourname>"
    exit 1
fi

# Environment Configuration
declare -x CLASS_NAME="agent"
declare -x MODULE_PATH="/usr/src/puppetlabs-training-bootstrap/modules"
declare -x RUBYLIB='/usr/src/puppet/lib:/usr/src/facter/lib'
declare -x puppet="/usr/src/puppet/bin/puppet"

# Setup hostname
$puppet apply \
--verbose \
--modulepath="${MODULE_PATH:?}" \
-e "include fundamental::${CLASS_NAME:?}"

# Respawn our shell
unset RUBYLIB
exec "$SHELL"
