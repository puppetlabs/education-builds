#! /bin/sh

source functions.sh
validate_args $*
version

echo "Verifying Extending classroom setup:"

###### start running checks ######

check "[ '`hostname`' == '${NAME}.puppetlabs.vm' ]"                 \
      "Checking hostname"                                           \
      "You should set the hostname to ${NAME}.puppetlabs.vm"

# `hostname -s` should be alphanumeric, can contain underscores, and
# contain at least one alphabetical character, with no caps, and finally,
# not be composed of all numerals:
check "echo `hostname -s` | grep -Pq '^(?=.*[a-z])\A[a-z0-9][a-z0-9._]+\z' " \
      "Checking hostname validity"                                  \
      "Hostnames should be alphanumeric with at least one alphabetical character"

check "ping -c1 master.puppetlabs.vm"                               \
      "Checking master name resolution"                             \
      "You should have an entry in /etc/hosts for master.puppetlabs.vm"

check "ping -c1 ${NAME}.puppetlabs.vm"                              \
      "Checking local hostname resolution"                          \
      "You should have an entry in /etc/hosts for ${NAME}.puppetlabs.vm"
