export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Main build
cd /usr/src/build_files

rake master_build

# Create token for deployer user
echo 'puppetlabs' | HOME=/root /opt/puppetlabs/bin/puppet-access login deployer --lifetime 365d
