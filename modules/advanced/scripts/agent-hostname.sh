#!/bin/bash

export FACTER_SET_HOSTNAME="$1"

if [ ${#FACTER_SET_HOSTNAME} -eq 0 ] ; then
    echo "Usage:"
    echo "$0 <yourname>"
    exit 1
fi

# Environment Configuration
declare -x MODULE_PATH="/usr/src/puppetlabs-training-bootstrap/modules"
declare -x RUBYLIB='/usr/src/puppet/lib:/usr/src/facter/lib'
declare -x puppet="/usr/src/puppet/bin/puppet"

# Setup hostname
$puppet apply \
--verbose \
--modulepath="${MODULE_PATH:?}" \
-e "include advanced::hostname"

# Respawn our shell
unset RUBYLIB
unset FACTER_SET_HOSTNAME
exec "$SHELL"
