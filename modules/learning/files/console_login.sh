#/bin/sh
sleep 12
echo; echo "Web console login:" >> /dev/tty1
echo "URL: https://$(/opt/puppet/bin/facter ipaddress_eth0)" >> /dev/tty1
echo "User: puppet@example.com" >> /dev/tty1
echo "Password: learningpuppet" >> /dev/tty1
