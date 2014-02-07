#!/bin/bash

# Extracts Puppet Enterprise (PE) idempotently
# - Meant to be used in /etc/rc.local to extract PE
#     if it's not already extracted
# - Can work with tar and tar.gz installers
# - If the installer is not already extracted, this:
#   - extract the tar or tar.gz file
#   - create a symlink "puppet-enterprise" in /root to 
#     point to the extracted directory

function extract()
{
  if [ -f $1 ] 
    then
      case $1 in
        *.tar.gz)
          tar xzf $1
          ;;
        *.tar)
          tar xf $1
          ;;
      esac
  fi
}

cd '/root'
installer=$(find /root -maxdepth 1 -type f -name 'puppet-enterprise-*')
archivefile="${installer##*/}"
dirname="${archivefile%.tar*}"

if [[ ! -z "$installer" ]] && [[ ! -d "/root/$dirname" ]]
  then
    extract $installer
    ln -s $dirname puppet-enterprise
    rm $installer
fi
