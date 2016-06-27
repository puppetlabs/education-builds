hostnamectl set-hostname learning.puppetlabs.vm

echo Build for PE version $PE_VERSION
PE_PATH="/training/file_cache/installers/puppet-enterprise-${PE_VERSION}-el-7-x86_64.tar.gz"
cp $PE_PATH /tmp/puppet-enterprise.tar.gz

cd /usr/src/build_files

rake master_pre

rm -rf /usr/src/build_files
