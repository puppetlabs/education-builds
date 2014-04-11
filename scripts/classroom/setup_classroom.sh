#! /bin/bash
source functions.sh
version

echo "This script will automate the setup of the Puppetlabs Training Classroom"
echo
offer_bailout

ipaddr=`hostname -I`
echo "Your IP address appears to be ${ipaddr}"
echo "If this is not correct, cancel now."
offer_bailout

while : ; do
  echo -n "Please choose a username: "
  read username

  [[ "$username" =~ ^[a-z0-9][a-z0-9._]+$ && "$username" =~ [a-z]+ ]] && break

  echo "Usernames must be lowercase alphanumeric with at least one letter."
  echo "... please try again."
done

while : ; do
  echo -n "Please enter the classroom Master's IP address: "
  read master

  ping -c1 -t2 ${master} >/dev/null 2>&1 && break

  echo "... that IP is unreachable."
done

echo "${master} master.puppetlabs.vm master" >> /etc/hosts
echo "${ipaddr} ${username}.puppetlabs.vm ${username}" >> /etc/hosts
sed -i "s/^HOSTNAME=.*$/HOSTNAME=${username}.puppetlabs.vm/" /etc/sysconfig/network
sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/CentOS-Base.repo
ntpdate master.puppetlabs.vm
hostname ${username}.puppetlabs.vm
source /etc/profile

# Now actually perform the install. Yay for packages!
curl -k https://master.puppetlabs.vm:8140/packages/current/install.bash | bash
