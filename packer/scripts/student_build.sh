# Install new ruby
sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | sudo bash -s stable --ruby=1.9.3

source /etc/profile.d/rvm.sh
rvm install 1.9.3-dev

cd /usr/src/

git clone https://github.com/puppetlabs/puppetlabs-training-bootstrap
cd /usr/src/puppetlabs-training-bootstrap/

rake student
