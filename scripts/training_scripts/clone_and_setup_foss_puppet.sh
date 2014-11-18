source ./setup_environment.sh
# Ensure ruby and git is available
yum install -y ruby ruby-devel rubygems rubygem-json git yumdownloader wget

# Setup FOSS projects in /usr/src
[ -d /usr/src ] || mkdir -p /usr/src

cd /usr/src/
git clone git://github.com/puppetlabs/puppet.git /usr/src/puppet
cd puppet && git fetch origin && git branch --set-upstream master origin/master && git checkout 3.6.2 ; cd /usr/src
git clone git://github.com/puppetlabs/facter.git /usr/src/facter
cd facter && git fetch origin && git branch --set-upstream master origin/master && git checkout 1.7.5 ; cd /usr/src
git clone git://github.com/puppetlabs/hiera.git /usr/src/hiera
cd hiera && git fetch origin && git branch --set-upstream master origin/master && git checkout 1.3.4 ; cd /usr/src
cd
