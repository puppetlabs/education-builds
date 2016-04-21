setenforce 0

cd /usr/src/
git clone https://github.com/puppetlabs/education-builds
cd /usr/src/education-builds/scripts

rake master_install

rm -rf /usr/src/education-builds/
