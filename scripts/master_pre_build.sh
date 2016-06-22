setenforce 0

echo Build for PE version $PE_VERSION
PE_PATH="/training/file_cache/installers/puppet-enterprise-${PE_VERSION}-el-7-x86_64.tar.gz"
cp $PE_PATH /tmp/puppet-enterprise.tar.gz

cd /usr/src/
git clone https://github.com/puppetlabs/education-builds
cd /usr/src/education-builds/scripts

rake master_pre

rm -rf /usr/src/education-builds/
