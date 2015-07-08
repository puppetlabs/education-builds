#!/bin/bash -eux

if grep -q -i "release 6" /etc/redhat-release ; then
  # Uninstall fuse to fake out the vmware install so it won't try to
  # enable the VMware blocking filesystem
  sudo yum erase -y fuse
fi
# Assume that we've installed all the prerequisites:
# kernel-headers-$(uname -r) kernel-devel-$(uname -r) gcc make perl
# from the install media via ks.cfg

cd /tmp
sudo mkdir -p /mnt/cdrom
sudo mount -o loop /home/vagrant/linux.iso /mnt/cdrom
sudo tar zxf /mnt/cdrom/VMwareTools-*.tar.gz -C /tmp/
sudo /tmp/vmware-tools-distrib/vmware-install.pl --default
rm /home/vagrant/linux.iso
sudo umount /mnt/cdrom
sudo rmdir /mnt/cdrom

