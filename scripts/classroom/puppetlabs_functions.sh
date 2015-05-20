COLUMNS=$(tput cols)
WIDTH=$[COLUMNS - 12]
ERRORCOUNT=0

function success ()
{
  MESSAGE="$1"
  printf "%-${WIDTH}s[\033[32m  OK  \033[0m]\n" "$MESSAGE"
}

function fail ()
{
  MESSAGE="$1"
  RESOLUTION="$2"
  ((++ERRORCOUNT))

  printf "%-${WIDTH}s[\033[31m FAIL \033[0m]\n" "$MESSAGE"

  if [ "$RESOLUTION" != "" ]
  then
    printf "  > %s\n" "$RESOLUTION"
  fi
}

function check_success ()
{
  STATUS=$?
  MESSAGE="$1"
  RESOLUTION="$2"

  if [ $STATUS -eq 0 ]
  then
    success "$MESSAGE"
    return 0
  else
    fail "$MESSAGE" "$RESOLUTION"
    return 1
  fi
}

function check ()
{
  COMMAND="$1"
  MESSAGE="$2"
  RESOLUTION="$3"

  eval "$COMMAND" > /dev/null 2>&1

  check_success "$MESSAGE" "$RESOLUTION"
}

function version ()
{
 if [ -f /etc/vm-version ]
 then
  echo "Version: `cat /etc/vm-version`"
  echo
 fi
}

function confirm()
{
  MESSAGE="$1"
  DEFAULT="$2"

  if [ "${DEFAULT}" = false ]; then
    echo -n "${MESSAGE} [y/N]: "
    read resp
    [[ "${resp}" == "" ]] && resp="n"
  else
    echo -n "${MESSAGE} [Y/n]: "
    read resp
    [[ "${resp}" == "" ]] && resp="y"
  fi

  [[ "${resp}" == "y" || "${resp}" == "Y" ]]
}

function offer_bailout()
{
  confirm "Do you wish to continue?" || exit 1
}
