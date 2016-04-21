hostnamectl set-hostname learning.puppetlabs.vm

cd /usr/src/
git clone https://github.com/puppetlabs/education-builds
cd /usr/src/education-builds/scripts

rake learning_install

rm -rf /usr/src/education-builds/
