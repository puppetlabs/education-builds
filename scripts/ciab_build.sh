export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Main build
cd /usr/src/build_files

rake ciab_build

rm -rf /usr/src/build_files
