#!/bin/bash
if [[ $1 =~ \.vmx$ ]]; then
  openssl sha1 $1 > output/puppet-$PE_VERSION-$VM_TYPE-$PTB_VERSION.mf
fi
if [[ $1 =~ \.ovf$ ]]; then
  # Clean up ovf
  if [ `uname` = "Darwin" ]; then
    # Use BSD syntax on OSX
    sed -i '' 's/virtualbox\-2\.2/vmx-09/' $1
    sed -i '' 's/MACAddress="[0-9A-F]*"/MACAddress=""/' $1
  else
    sed -i 's/virtualbox\-2\.2/vmx-09/' $1
    sed -i 's/MACAddress="[0-9A-F]*"/MACAddress=""/' $1
  fi
  # Remove previous build
  rm -f output/puppet-$PE_VERSION-$VM_TYPE-$PTB_VERSION.ova
  # Recreate ova manifest after file changes
  openssl sha1 $1 >> output/puppet-$PE_VERSION-$VM_TYPE-$PTB_VERSION.mf
  ovftool --targetType=ova --acceptAllEulas $1 output/puppet-$PE_VERSION-$VM_TYPE-$PTB_VERSION.ova
fi
