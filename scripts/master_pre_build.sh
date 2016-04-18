setenforce 0

cd /usr/src/
git clone https://github.com/puppetlabs/puppetlabs-training-bootstrap
cd /usr/src/puppetlabs-training-bootstrap/

rake master_install

rm -rf /usr/src/puppetlabs-training-bootstrap/
