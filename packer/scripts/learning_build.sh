mkdir -p /opt/lvmguide
mv /vagrant/file_cache/lvmguide-0.3.0.zip /opt/lvmguide
cd /opt/lvmguide/
unzip lvmguide-0.3.0.zip
mv /opt/lvmguide/quest_tool/* /root
mv /opt/lvmguide/quest_tool/.testing /root


yum install -y git yum-utils ruby-devel ruby rubygems
gem install rake json

cd /usr/src/
git clone https://github.com/puppetlabs/puppetlabs-training-bootstrap
cd /usr/src/puppetlabs-training-bootstrap/

rake -f Rakefile.new learning

#Disable update for pre-release build
#rm -rf /root/.testing
#/root/bin/quest update
