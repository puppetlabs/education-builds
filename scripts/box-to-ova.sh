#!/bin/bash
cd output
mkdir temp
mv $1 temp
cd temp
tar xzvf
ovftool --targetType=ova --acceptAllEulas output/temp/student.vmx output/puppet-$PE_VERSION-$VM_TYPE-$PTB_VERSION.ova
