#!/bin/bash

set -e
set -u

PATCHBIN=${PATCHBIN:='/usr/bin/patch'}
OSSLBIN=${OSSLBIN:='/opt/local/bin/openssl'}
SEDBIN=${SEDBIN:='/usr/bin/sed'}
OVFTOOL=${OVFTOOL:='/opt/vmware/ovftool/ovftool'}
OVFOPS=${OVFOPS:='-dm=monolithicSparse'}
OSVER=${OSVER:='5.5'}
OSDIST=${OSDIST:='centos'}
PUPPETVER=${PUPPETVER:='pe-1.1'}
VMDIST=${VMDIST:='vmware'}

PATCH='--- CentOS-min.ovf       2010-08-27 12:11:48.000000000 -0700
+++ CentOS-min-edit.ovf  2010-08-27 12:14:38.000000000 -0700
@@ -14,11 +14,12 @@
       <Description>The nat network</Description>
     </Network>
   </NetworkSection>
-  <VirtualSystem ovf:id="vm">
+  <VirtualSystem ovf:id="Puppet Training">
     <Info>A virtual machine</Info>
     <Name>Puppet Training</Name>
-    <OperatingSystemSection ovf:id="36" vmw:osType="centosGuest">
+    <OperatingSystemSection ovf:id="79">
       <Info>The kind of installed guest operating system</Info>
+      <Description>RedHat</Description>
     </OperatingSystemSection>
     <VirtualHardwareSection>
       <Info>Virtual hardware requirements</Info>
@@ -72,4 +73,4 @@
       </Item>
     </VirtualHardwareSection>
   </VirtualSystem>
-</Envelope>
\ No newline at end of file
+</Envelope>'

${OVFTOOL} ${OVFOPS} ../${OSDIST}-${OSVER}-${PUPPETVER}-${VMDIST}/CentOS-min.vmx ${PWD}/CentOS-min.ovf

OVFFILE=`ls ${PWD} | grep \.ovf$`
MFFILE=`ls ${PWD} | grep \.mf$`

${PATCHBIN} ${OVFFILE} --posix --silent -u -i - <<PATCH_EOF
${PATCH}
PATCH_EOF

rm -f ${OVFFILE}.rej
rm -f ${OVFFILE}.orig

NEWSHA=`${OSSLBIN} sha1 ${OVFFILE}`

${SEDBIN} s/"SHA1(CentOS-min.ovf.*"/"${NEWSHA}"/ ${MFFILE} > ${MFFILE}.tmp
mv ${MFFILE}.tmp ${MFFILE}
