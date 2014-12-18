# Make sure udev doesn't block our network
if grep -q -i "release 6" /etc/redhat-release ; then
    rm -rf /etc/udev/rules.d/70-persistent-net.rules
    rm -rf /lib/udev/rules.d/75-persistent-net-generator.rules
fi
rm -rf /dev/.udev/
sed -i -e "/^HWADDR.*/d" /etc/sysconfig/network-scripts/ifcfg-eth0

yum clean all -y

rm -rf /tmp/*
rm -rf /vagrant
