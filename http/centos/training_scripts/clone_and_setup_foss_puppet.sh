# Ensure ruby and git is available
yum install -y ruby ruby-devel rubygems rubygem-json git

# Setup FOSS projects in /usr/src
[ -d /usr/src ] || mkdir -p /usr/src

cd /usr/src/
git clone git://github.com/puppetlabs/puppet.git /usr/src/puppet
cd puppet && git remote rename origin ks && git remote add origin git://github.com/puppetlabs/puppet.git && git fetch origin && git branch --set-upstream master origin/master && git checkout 3.2.4 ; cd /usr/src
git clone git://github.com/puppetlabs/facter.git /usr/src/facter
cd facter && git remote rename origin ks && git remote add origin git://github.com/puppetlabs/facter.git && git fetch origin && git branch --set-upstream master origin/master && git checkout 1.7.1 ; cd /usr/src
git clone git://github.com/puppetlabs/hiera.git /usr/src/hiera
cd hiera && git remote rename origin ks && git remote add origin git://github.com/puppetlabs/hiera.git && git fetch origin && git branch --set-upstream master origin/master && git checkout 1.2.1 ; cd /usr/src
cd
