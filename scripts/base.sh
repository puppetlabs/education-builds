set -e
# Base install
yum update -y
yum install -y wget curl rake

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
sed -i "s/^\(.*env_keep = \"\)/\1PATH /" /etc/sudoers

# Ensure NFS mounts work properly
yum install -y nfs-utils 

# Install devlopment tools
yum groupinstall -y "Development Tools"

