yum install -y git yum-utils ruby-devel ruby rubygems
gem install rake json

cd /usr/src/
git clone https://github.com/puppetlabs/puppetlabs-training-bootstrap
cd /usr/src/puppetlabs-training-bootstrap/

rake -f Rakefile.new learning
