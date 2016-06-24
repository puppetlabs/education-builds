# Base install
yum update -y
yum install -y wget curl rake

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
sed -i "s/^\(.*env_keep = \"\)/\1PATH /" /etc/sudoers

# Ensure NFS mounts work properly
yum install -y nfs-utils 

# Install devlopment tools
yum groupinstall -y "Development Tools"

if ! ( [ -f /sys/hypervisor/uuid ] && [ `head -c 3 /sys/hypervisor/uuid` == ec2 ] ); then
  # Installing the virtualbox guest additions
  mount -o loop VBoxGuestAdditions.iso /mnt
  sh /mnt/VBoxLinuxAdditions.run
  umount /mnt
fi
