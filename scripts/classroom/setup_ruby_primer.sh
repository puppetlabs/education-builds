#!/bin/bash
if [ ! -f /root/.extendingrc ]; then
  echo "Installing the Puppet Enterprise ruby packages."
  yum localinstall --disablerepo=* /root/puppet-enterprise/packages/el-6-i386/pe-ruby*
  touch .extendingrc
  echo "Please run 'exec bash' or 'exec zsh' to update your PATH."
else
  echo "This script has already installed the required packages. Please try 'exec bash' or 'exec zsh' to set your PATH."
fi

