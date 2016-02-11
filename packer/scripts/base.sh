# Base install
sudo yum install -y wget curl rake


sudo sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
sudo sed -i "s/^\(.*env_keep = \"\)/\1PATH /" /etc/sudoers

# Ensure NFS mounts work properly
sudo yum install -y nfs-utils 

# Install devlopment tools
sudo yum groupinstall -y "Development Tools"
