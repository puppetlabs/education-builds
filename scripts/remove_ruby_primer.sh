#!/bin/bash

if [ -f /root/.extendingrc ]; then
  echo "Removing Puppet Enterprise ruby RPMs."
  for i in $(rpm -qa | grep pe-ruby*);
    do
      rpm -e --nodeps $i;
    done
  rm -fr /root/.extendingrc
  echo "Please run 'exec bash' or 'exec zsh' to update your PATH."
else
  echo "This script will remove all pe-ruby* RPMS and should only be used in the Extending Puppet with Ruby course." 
fi
