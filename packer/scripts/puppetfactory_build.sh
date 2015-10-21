export PATH=/usr/local/bin:/usr/local/sbin:$PATH

cd /usr/src/
git clone https://github.com/puppetlabs/puppetlabs-training-bootstrap
cd /usr/src/puppetlabs-training-bootstrap/

rake puppetfactory
