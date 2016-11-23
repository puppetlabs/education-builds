hostnamectl set-hostname learning.puppetlabs.vm

echo Build for PE version $PE_VERSION

cd /usr/src/build_files

rake master_pre
rake master_build

rm -rf /usr/src/build_files
