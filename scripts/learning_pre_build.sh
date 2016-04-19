hostnamectl set-hostname learning.puppetlabs.vm

cd /usr/src/
git clone https://github.com/puppetlabs/puppetlabs-training-bootstrap
cd /usr/src/puppetlabs-training-bootstrap/scripts

rake learning_install

rm -rf /usr/src/puppetlabs-training-bootstrap/
