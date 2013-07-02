NAME=$1
COLUMNS=$(tput cols)
WIDTH=$[COLUMNS - 12]

if [ $# -ne 1 ]
then
  echo "Please call this script with the username you provided to the instructor."
  echo "For example, ${0} <myname>"
  exit 1
fi

function success ()
{
  MESSAGE="$1"
  printf "%-${WIDTH}s[\033[32m  OK  \033[0m]\n" "$MESSAGE"
}

function fail ()
{
  MESSAGE="$1"
  RESOLUTION="$2"
  printf "%-${WIDTH}s[\033[31m FAIL \033[0m]\n" "$MESSAGE"
  printf "  > %s\n" "$RESOLUTION"
}

function check ()
{
  COMMAND="$1"
  MESSAGE="$2"
  RESOLUTION="$3"

  $COMMAND > /dev/null 2>&1

  if [ $? -eq 0 ]
  then
    success "$MESSAGE"
  else
    fail "$MESSAGE" "$RESOLUTION"
  fi
}

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


