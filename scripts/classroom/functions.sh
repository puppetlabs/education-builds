COLUMNS=$(tput cols)
WIDTH=$[COLUMNS - 12]

function validate_args()
{
  if [ $# -ne 1 ]
  then
    echo "Please call this script with the username you provided to the instructor."
    echo "For example, ${0} <myname>"
    exit 1
  fi

  NAME=$1
}

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

  eval "$COMMAND" > /dev/null 2>&1

  if [ $? -eq 0 ]
  then
    success "$MESSAGE"
    return 0
  else
    fail "$MESSAGE" "$RESOLUTION"
    return 1
  fi
}

function version ()
{
 if [ -f /etc/puppetlabs-release ]
 then
  echo "Version: `cat /etc/puppetlabs-release`"
  echo
 fi
}

function offer_bailout()
{
  echo -n "Do you wish to continue? [Y/n]: "
  read resp

  [[ "${resp}" != "" && "${resp}" != "y" && "${resp}" != "Y" ]] && exit 1
}
