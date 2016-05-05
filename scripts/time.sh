# Install ntpdate and update time
yum -y install ntpdate
timedatectl set-timezone America/Los_Angeles
/sbin/ntpdate time.apple.com
