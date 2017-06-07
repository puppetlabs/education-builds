export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Main build
cd /usr/src/build_files

rake standalone_agent_full

rm -rf /usr/src/build_files
