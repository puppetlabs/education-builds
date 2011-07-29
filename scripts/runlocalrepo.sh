#!/bin/bash
# set up local Puppet environment to 
# run localrepo.pp
#
PUPPET_HOME=/opt/puppetlabs/puppet
export RUBYLIB=$PUPPET_HOME/lib
export PATH=$PUPPET_HOME/bin/:$PUPET_HOME/sbin/:$PATH
puppet apply localrepo.pp
