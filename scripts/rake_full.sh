hostnamectl set-hostname learning.puppetlabs.vm

cd /usr/src/build_files && rake full
rm -rf /usr/src/build_files
