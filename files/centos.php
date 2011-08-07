<?php
header("Content-Type: text/plain");
echo("# host is " . $_SERVER['SERVER_NAME'] . "\n");
$host = $_SERVER['SERVER_NAME'];
preg_match('^/~(\w+)/^', $_SERVER['REQUEST_URI'], $user_match);
$user = $user_match[1];
?>
# product: centos
# version: 5
# arch: x64

# System authorization information
auth  --useshadow  --enablemd5  --enablecache
# System bootloader configuration
bootloader --location=mbr
# Clear the Master Boot Record
zerombr
# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
part /boot --fstype ext2 --size=100
part pv.01 --size=1 --grow
volgroup vg00 pv.01
logvol / --name=rootvol --vgname=vg00 --size=1 --grow --fstype ext3
logvol swap --name=swapvol --vgname=vg00 --size=256
# Use text mode install
#text
# Use the *real* text mode install
cmdline
# Firewall configuration
firewall --disabled
# Run the Setup Agent on first boot
firstboot --disable
# System keyboard
keyboard us
# System language
lang en_US
# Installation logging level
logging --level=info
# Use network installation
url --url=http://<? echo($host . '/~' . $user); ?>/dvd
# Network information
network --bootproto=dhcp --device=eth0 --onboot=on
# Reboot after installation
reboot
#Root password
rootpw --iscrypted $1$jrm5tnjw$h8JJ9mCZLmJvIxvDLjw1M/

# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx
# System timezone
timezone UTC
# Install OS instead of upgrade
install

#Packages
%packages
@Core
@base
@editors
ntp
curl
tar
ruby

%post
exec < /dev/tty3 > /dev/tty3
chvt 3
(
set -x
cd /root
#sed -i "s/HOSTNAME.*/HOSTNAME=centos64/" /etc/sysconfig/network
curl -s http://<? echo($host . '/~' . $user); ?>/ks/puppet-enterprise-1.1-centos-5-x86_64.tar | tar xf -
rpm -Uvh http://<? echo($host . '/%7E' . $user); ?>/ks/epel-release-5-4.noarch.rpm
yum -y install git
yum -y upgrade
cd /usr/src
git clone http://<? echo($host . '/~' . $user); ?>/ks/puppet.git
git clone http://<? echo($host . '/~' . $user); ?>/ks/facter.git
git clone http://<? echo($host . '/~' . $user); ?>/ks/mcollective.git
git clone http://<? echo($host . '/~' . $user); ?>/ks/puppetlabs-training-bootstrap.git
cd /root
RUBYLIB=/usr/src/puppet/lib:/usr/src/facter/lib
export RUBYLIB
/usr/src/puppet/bin/puppet apply --modulepath=/usr/src/puppetlabs-training-bootstrap/modules --verbose /usr/src/puppetlabs-training-bootstrap/manifests/site.pp
echo 'Hello, World!'
) 2>&1 | /usr/bin/tee /root/post.log
chvt 1
