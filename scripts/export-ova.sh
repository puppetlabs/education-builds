#!/bin/bash
#if [[ $1 =~ \.vmx$ ]]; then
# ovftool --targetType=ova --acceptAllEulas $1 output/puppet-$PE_VERSION-$VM_TYPE-$PTB_VERSION.ova
#fi
if [[ $1 =~ \.ovf$ ]]; then
  sed -i '' 's/virtualbox\-2\.2/vmx-09/' $1
  sed -i '' 's/MACAddress="[0-9A-F]*"/MACAddress=""/' $1
  ovftool --targetType=ova --acceptAllEulas $1 output/puppet-$PE_VERSION-$VM_TYPE-$PTB_VERSION.ova
fi
