# Make sure udev doesn't block our network
if uname -r | grep -q el6 ; then
  rm -rf /etc/udev/rules.d/70-persistent-net.rules
  rm -rf /lib/udev/rules.d/75-persistent-net-generator.rules
  sed -i -e "/^HWADDR.*/d" /etc/sysconfig/network-scripts/ifcfg-eth0
else
  # Workaround for Centos 7 bug that sets incorrect device name
  export INTERFACE=`ip link | awk '/ens/{ gsub(":",""); print $2}'`
  mv /etc/sysconfig/network-scripts/ifcfg-ens* /etc/sysconfig/network-scripts/ifcfg-$INTERFACE
  sed -i "s/ens[0-9]\{2\}/$INTERFACE/" /etc/sysconfig/network-scripts/ifcfg=$INTERFACE
fi
rm -rf /dev/.udev/

yum clean all -y

rm -rf /training
rm -rf /etc/puppet


