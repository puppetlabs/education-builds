# Make sure udev doesn't block our network
if uname -r | grep -q el6 ; then
    sudo rm -rf /etc/udev/rules.d/70-persistent-net.rules
    sudo rm -rf /lib/udev/rules.d/75-persistent-net-generator.rules
    sudo sed -i -e "/^HWADDR.*/d" /etc/sysconfig/network-scripts/ifcfg-eth0
else
  # Workaround for Centos 7 bug that sets incorrect device name
  export INTERFACE=`ip link | awk '/ens/{ gsub(":",""); print $2}`
  sudo mv /etc/sysconfig/network-scripts/ifcfg-ens* /etc/sysconfig/network-scripts/ifcfg-$INTERFACE
  sudo sed -i "s/ens[0-9]\{2\}/$INTERFACE" /etc/sysconfig/network-scripts/ifcfg=$INTERFACE
fi
sudo rm -rf /dev/.udev/

sudo yum clean all -y

sudo rm -rf /tmp/*
sudo rm -rf /vagrant
sudo rm -rf /etc/puppet


