setenforce 0

echo Build for PE version $PE_VERSION

cd /usr/src/build_files

rake ciab_pre

rm -rf /usr/src/build_files
