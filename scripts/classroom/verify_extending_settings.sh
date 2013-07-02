source functions.sh

echo "Verifying Extending classroom setup:"

###### start running checks ######

check "[ '`hostname`' == '${NAME}.puppetlabs.vm' ]"                 \
      "Checking hostname"                                           \
      "You should set the hostname to ${NAME}.puppetlabs.vm"

check "grep HOSTNAME=${NAME}.puppetlabs.vm /etc/sysconfig/network"  \
      "Checking that the hostname will be set on boot"              \
      "You should set HOSTNAME=${NAME}.puppetlabs.vm in /etc/sysconfig/network"

check "ping -c1 master.puppetlabs.vm"                               \
      "Checking master name resolution"                             \
      "You should have an entry in /etc/hosts for master.puppetlabs.vm"

check "ping -c1 ${NAME}.puppetlabs.vm"                              \
      "Checking local hostname resolution"                          \
      "You should have an entry in /etc/hosts for ${NAME}.puppetlabs.vm"
