#! /bin/bash
source puppetlabs_functions.sh
version

echo "This script will automate the setup of the Puppetlabs Training Classroom"
echo

if [ "`hostname`" == 'master.puppetlabs.vm' ]
then
  echo 'Do not run on the classroom master'
  exit 1
fi

puppet --version > /dev/null 2>&1
if [ $? -eq 0 ]
then
  echo 'You appear to already have Puppet installed. Is this the Learning VM?'
  exit 2
fi

offer_bailout

# backup /etc/hosts and /etc/sysconfig/network
HOSTS=/etc/hosts
NETWORK=/etc/sysconfig/network
BACKUP_DIR=$(mktemp -d)
cp "$HOSTS" "$BACKUP_DIR"
cp "$NETWORK" "$BACKUP_DIR"

function validate_name
{
  name="$1"

  [[ "${name}" =~ ^[a-z][a-z0-9]{2,}$     &&
     "${name}" =~ [a-z]+                  &&
     "${name}" != "root"                  &&
     "${name}" != "student"               &&
     "${name}" != "master" ]]
}
IP_FOUND=false
IP_LIST=(`hostname -I`)
IP_COUNT=${#IP_LIST[*]}

if [ ${IP_COUNT} -ge 2 ]
then
  echo "There are ${IP_COUNT} IP Addresses associated with this system."
  for i in `seq ${IP_COUNT}`; do
    echo $i ":" ${IP_LIST[(${i} - 1)]}
  done
fi

for ipaddr in ${IP_LIST[*]}; do
  if confirm "Is ${ipaddr} your primary IP Address? " true
  then
    IP_FOUND=true
    break
  fi
done

if [ $IP_FOUND != 'true' ]
then
  echo 'You must specify an ipaddress to set up agent'
  exit 3
fi

while : ; do
  echo -n "Please choose a name for this node and for your console username: "
  read username

  validate_name $username && break

  echo "Node names in the classroom must be lowercase alphanumeric; with at least one"
  echo "letter, no periods, and not a reserved name such as 'root' or 'master'."
  echo "... please try again."
done

while : ; do
  echo -n "Please enter the classroom Master's IP address: "
  read master

  ping -c1 -W2 ${master} >/dev/null 2>&1 && break

  echo "... that IP is unreachable."
done

if confirm "Are you creating a secondary agent in the Architect course?" false
then

  while : ; do
    echo -n "Please enter the node name you chose for your Master: "
    read student_master_name

    echo -n "Please enter the IP address for ${student_master_name}.puppetlabs.vm: "
    read student_master_ip

    ping -c1 ${student_master_ip} >/dev/null 2>&1 && break

    echo "... that IP is unreachable."
  done

  hostname="${username}.${student_master_name}"
  aliases="${username}.${student_master_name} ${username}"
  install_args="-s agent:ca_server=master.puppetlabs.vm"
  install_host="${student_master_name}.puppetlabs.vm"
else
  hostname="${username}":
  aliases="${username}"
  install_args="-s main:user=pe-puppet -s main:group=pe-puppet -s main:mkusers=true"
  install_host="master.puppetlabs.vm"
fi


################  start configuring the node ###################
check_success "Adding host record for classroom master"             \
      "$(echo "${master} master.puppetlabs.vm master" >> /etc/hosts 2>&1)"

check_success "Adding host record for ${hostname}.puppetlabs.vm"    \
      "$(echo "${ipaddr} ${hostname}.puppetlabs.vm ${aliases}" >> /etc/hosts 2>&1)"

if [ "${student_master_name}" != "" ]
then
  check_success "Adding host record for ${student_master_name}.puppetlabs.vm"    \
      "$(echo "${student_master_ip} ${student_master_name}.puppetlabs.vm ${student_master_name}" >> /etc/hosts 2>&1)"
fi

check_success "Configuring hostname"                                \
      "$(hostname ${hostname}.puppetlabs.vm 2>&1)"

check_success "Setting hostname on boot"                            \
      "$(sed -i "s/^HOSTNAME=.*$/HOSTNAME=${hostname}.puppetlabs.vm/" /etc/sysconfig/network 2>&1)"

check_success "Synchronizing time with the classroom master"        \
      "$(ntpdate -u master.puppetlabs.vm 2>&1)"


################  only install puppet if there were no errors ###################
if [ $ERRORCOUNT -eq 0 ]
then
  source /etc/profile

  # Now actually perform the install. Yay for packages!
  echo "Installing Puppet Enterprise Agent..."
  curl -k https://${install_host}:8140/packages/current/install.bash | bash ${install_args}

  [ $? -ne 0 ] && ((++ERRORCOUNT))

  # create environments directory so we can populate it later
  mkdir -p /etc/puppetlabs/puppet/environments

  # snapshot $ssldir for engineering debug purposes
  snapshot.sh ssldir
fi

if [ $ERRORCOUNT -eq 0 ]
then
  rm -rf "$BACKUP_DIR"
else
  echo
  echo 'Please correct the errors displayed before trying again.'

  # restore backup files
  cp "${BACKUP_DIR}/hosts" "$HOSTS"
  cp "${BACKUP_DIR}/network" "$NETWORK"
fi
