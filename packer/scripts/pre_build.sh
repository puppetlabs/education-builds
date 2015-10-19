sudo yum install -y git yum-utils rubygems
sudo gem install rake json

# Install new ruby
sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | sudo bash -s stable --ruby=1.9.3
