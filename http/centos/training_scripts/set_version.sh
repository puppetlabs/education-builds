#!/bin/bash

if [ -f /usr/src/puppetlabs-training-bootstrap/scripts/version.rb ] then
  /usr/src/puppetlabs-training-bootstrap/version.rb >> /etc/puppetlabs-released
fi
