# Make sure udev doesn't block our network on centos 6
if uname -r | grep -q el6 ; then
  rm -rf /etc/udev/rules.d/70-persistent-net.rules
  rm -rf /lib/udev/rules.d/75-persistent-net-generator.rules
  sed -i -e "/^HWADDR.*/d" /etc/sysconfig/network-scripts/ifcfg-eth0
fi
rm -rf /dev/.udev/

yum clean all -y

rm -rf /training
rm -rf /etc/puppet


