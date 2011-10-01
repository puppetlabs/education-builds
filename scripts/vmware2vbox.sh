#!/bin/bash

set -e
set -u

PATCHBIN=${PATCHBIN:='/usr/bin/patch'}
OSSLBIN=${OSSLBIN:='/opt/local/bin/openssl'}
SEDBIN=${SEDBIN:='/usr/bin/sed'}
OVFTOOL=${OVFTOOL:='/opt/vmware/ovftool/ovftool'}
OVFOPS=${OVFOPS:='-dm=monolithicSparse'}
OSVER=${OSVER:='5.6'}
OSDIST=${OSDIST:='centos'}
PUPPETVER=${PUPPETVER:='pe-1.2.3'}
VMDIST=${VMDIST:='vmware'}
VMNAME=${OSDIST}-${OSVER}-${PUPPETVER}-${VMDIST}

PATCH='--- centos-5.6-pe-1.2.3-vmware.ovf	2011-09-27 05:52:34.000000000 -0400
+++ centos-5.6-pe-1.2.3-vmware.ovf.new	2011-09-27 05:56:31.000000000 -0400
@@ -14,11 +14,12 @@
       <Description>The nat network</Description>
     </Network>
   </NetworkSection>
-  <VirtualSystem ovf:id="vm">
+  <VirtualSystem ovf:id="Puppet Training">
     <Info>A virtual machine</Info>
     <Name>Puppet Training</Name>
-    <OperatingSystemSection ovf:id="1" vmw:osType="otherGuest">
+    <OperatingSystemSection ovf:id="79">
       <Info>The kind of installed guest operating system</Info>
+      <Description>RedHat</Description>
     </OperatingSystemSection>
     <VirtualHardwareSection>
       <Info>Virtual hardware requirements</Info>'

${OVFTOOL} ${OVFOPS} ../${VMNAME}/${VMNAME}.vmx ${PWD}/${VMNAME}.ovf

OVFFILE=`ls ${PWD} | grep \.ovf$`
MFFILE=`ls ${PWD} | grep \.mf$`

${PATCHBIN} ${OVFFILE} --posix --silent -u -i - <<PATCH_EOF
${PATCH}
PATCH_EOF

rm -f ${OVFFILE}.rej
rm -f ${OVFFILE}.orig

NEWSHA=`${OSSLBIN} sha1 ${OVFFILE}`

${SEDBIN} s/"SHA1(${VMNAME}.ovf.*"/"${NEWSHA}"/ ${MFFILE} > ${MFFILE}.tmp
mv ${MFFILE}.tmp ${MFFILE}
