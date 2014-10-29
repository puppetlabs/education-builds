#! /bin/sh

source puppetlabs_functions.sh
version

if [ $# -ne 1 ]
then
  echo "Please call this script with the username you provided to the instructor."
  echo "For example, ${0} <myname>"
  exit 1
fi
NAME=$1

echo "Verifying Puppet Labs Training classroom setup:"

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

check "grep HOSTNAME=${NAME}.puppetlabs.vm /etc/sysconfig/network"  \
      "Checking that the hostname will be set on boot"              \
      "You should set HOSTNAME=${NAME}.puppetlabs.vm in /etc/sysconfig/network"

check "ping -c1 master.puppetlabs.vm"                               \
      "Checking master name resolves and is pingable"               \
      "You should have an entry in /etc/hosts for master.puppetlabs.vm"

check "ping -c1 ${NAME}.puppetlabs.vm"                              \
      "Checking local hostname resolution"                          \
      "You should have an entry in /etc/hosts for ${NAME}.puppetlabs.vm"

# Checks for only the master go below this line
[[ "`hostname`" != 'master.puppetlabs.vm' ]]  && exit 0

check "[[ '`grep processor /proc/cpuinfo | wc -l`' -gt '1' ]]"      \
      "Checking core count for classroom Master"                    \
      "You should give the virtual machine for the classroom Master at least two cores"

check "[[ \"`awk '/MemTotal/{print $2}' /proc/meminfo`\" -ge '4019584' ]]"   \
      "Checking available memory for classroom Master"              \
      "You should give the virtual machine for the classroom Master at least 4GB of memory"

DEFAULT='$1$jrm5tnjw$h8JJ9mCZLmJvIxvDLjw1M/'  # 'puppet'
check "[[ '$(awk -F ':' '/^root/{print $2}' /etc/shadow)' != '$DEFAULT' ]]"  \
      "Verifying that the default password has been changed"        \
      "You should change root's password before proceeding"
