#!/bin/bash
if [ ! -f /root/.extendingrc ]; then
  echo "Installing the Puppet Enterprise ruby packages."
  cd /root/puppet-enterprise/packages/el-6-i386/
  yum localinstall --disablerepo=* pe-augeas*.rpm pe-libevent*.rpm pe-libyaml*.rpm pe-ruby-1.9.3*.rpm pe-ruby-augeas*.rpm pe-bundler*.rpm
  touch .extendingrc
  echo "Please run 'exec bash' or 'exec zsh' to update your PATH."
else
  echo "This script has already installed the required packages. Please try 'exec bash' or 'exec zsh' to set your PATH."
fi
