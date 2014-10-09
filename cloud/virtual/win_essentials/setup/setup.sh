#! /bin/sh

#optional major version number, defaults to 7
DISTRO=${1:-"7"}
PASSWORD="puppet"
VERSION="3.3.2"
BUILD="puppet-enterprise-${VERSION}-el-${DISTRO}-x86_64"
FILENAME="${BUILD}.tar.gz"

curl -O https://s3.amazonaws.com/pe-builds/released/${VERSION}/${FILENAME}
tar -xvzf ${FILENAME} -C /root/
cp answers.txt /root/${BUILD}/

sed -i "s/^PasswordAuthentication no$/PasswordAuthentication yes/" /etc/ssh/sshd_config
sed -i "s/^PermitRootLogin.*$/PermitRootLogin yes/" /etc/ssh/sshd_config
service sshd restart

#echo "root:${PASSWORD}" | chpasswd
cp 99_puppetlabs.cfg /etc/cloud/cloud.cfg.d/

cp vimrc /root/.vimrc
cp -a vim /root/.vim

cp newpass.sh /root/

yum update -y
yum install vim tree git -y

# for clean up
cp bash_logout /home/ec2-user/.bash_logout

