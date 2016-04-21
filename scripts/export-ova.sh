#!/bin/bash
if [[ $1 =~ \.vmx$ ]]; then
 ovftool --targetType=ova --acceptAllEulas $1 output/puppet-$PE_VERSION-$VM_TYPE-$PTB_VERSION.ova
fi
