#! /bin/sh

#optional major version number, defaults to 6
VER=${1:-"6"}
HOSTNAME="learn.puppetlabs.com"
PASSWORD="puppet"

curl -O https://s3.amazonaws.com/pe-builds/released/3.3.2/puppet-enterprise-3.3.2-el-${VER}-x86_64.tar.gz
tar -xvzf puppet-enterprise-3.3.2-el-${VER}-x86_64.tar.gz

echo "127.0.0.1   ${HOSTNAME}" > /etc/hosts
sed -i "s/^HOSTNAME=.*$/HOSTNAME=${HOSTNAME}/" /etc/sysconfig/network
sed -i "s/^PasswordAuthentication no$/PasswordAuthentication yes/" /etc/ssh/sshd_config
sed -i "s/^PermitRootLogin.*$/PermitRootLogin yes/" /etc/ssh/sshd_config
service sshd restart

echo "root:${PASSWORD}" | chpasswd
cp 99_puppetlabs.cfg /etc/cloud/cloud.cfg.d/

cp bashrc /root/.bashrc
cp vimrc /root/.vimrc
cp -a vim /root/.vim
cp bash.bash_logout /etc/
cp profile.sh /etc/profile.d/puppet.sh

yum update -y

cp puppet_enterprise-el${VER}.repo /etc/yum.repos.d/puppet_enterprise.repo
yum install -y git tree pe-puppet-server pe-puppet

PATH=/opt/puppet/bin:$PATH
puppet config set certname ${HOSTNAME}
puppet config set server ${HOSTNAME}
puppet cert --generate ${HOSTNAME} --dns_alt_names "puppet,${HOSTNAME}" --verbose
cp site.pp /etc/puppetlabs/puppet/manifests

if [ ${VER} == 7 ]
then
  cp pe-puppet-master.service /usr/lib/systemd/system/
else
  cp pe-puppet-master /etc/init.d
fi

puppet resource service pe-puppet-master ensure=running enable=true

# for clean up
cp bash_logout /home/ec2-user/.bash_logout
