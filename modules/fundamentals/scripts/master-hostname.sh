#!/bin/bash

# Environment Configuration
declare -x MODULE_PATH="/usr/src/puppetlabs-training-bootstrap/modules"
declare -x RUBYLIB='/usr/src/puppet/lib:/usr/src/facter/lib'
declare -x puppet="/usr/src/puppet/bin/puppet"
declare -x CLASS_NAME="master"

# Setup hostname
$puppet apply \
--verbose \
--modulepath="${MODULE_PATH:?}" \
-e "include fundamentals::${CLASS_NAME:?}"

# Respawn our shell
unset RUBYLIB
exec "$SHELL"
