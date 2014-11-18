source ./setup_environment.sh
# Set the dns info and hostname; must be done before puppet
echo "hostname training.puppetlabs.vm"
hostname training.puppetlabs.vm
echo "Editing /etc/hosts"
sed -i "s/127\.0\.0\.1.*/127.0.0.1 training.puppetlabs.vm training localhost localhost.localdomain localhost4/" /etc/hosts
echo "Editing /etc/sysconfig/network"
sed -ie "s/HOSTNAME.*/HOSTNAME=training.puppetlabs.vm/" /etc/sysconfig/network
echo 'prepend domain-search "puppetlabs.vm"' >> /etc/dhcp/dhclient-eth0.conf
