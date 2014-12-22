mkdir -p /opt/lvmguide
mv /vagrant/file_cache/lvmguide-0.2.3.zip /opt/lvmguide

yum install -y git yum-utils ruby-devel ruby rubygems
gem install rake json

cd /usr/src/
git clone https://github.com/joshsamuelson/puppetlabs-training-bootstrap -b lvm/swap_fix
cd /usr/src/puppetlabs-training-bootstrap/

rake -f Rakefile.new learning

rm -rf /root/.testing
/root/bin/quest update
