sudo mkdir -p /opt/lvmguide
sudo mv /vagrant/file_cache/lvmguide-0.3.0.zip /opt/lvmguide
cd /opt/lvmguide/
sudo unzip lvmguide-0.3.0.zip
sudo mv /opt/lvmguide/quest_tool/* /root
sudo mv /opt/lvmguide/quest_tool/.testing /root


cd /usr/src/
git clone https://github.com/puppetlabs/puppetlabs-training-bootstrap
cd /usr/src/puppetlabs-training-bootstrap/

sudo rake learning

#Disable update for pre-release build
#rm -rf /root/.testing
#/root/bin/quest update
