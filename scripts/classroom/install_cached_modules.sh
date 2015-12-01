#! /bin/bash

echo
echo "################################################################################"
echo "   This script will install cached versions of modules used in the classroom."
echo "     This should only be used when public Internet access is not available."
echo
echo "             Press Control-C now to abort or [enter] to continue."
echo
echo "################################################################################"
echo
read junk

for tarball in /usr/src/forge/*; do
  module=$(basename ${tarball})
  module="${module#*-}"
  module="${module%%-*}"

  echo "Installing: ${module}"

  mkdir /etc/puppetlabs/code/modules/${module}
  tar -xf $tarball -C /etc/puppetlabs/code/modules/${module} --strip-components 1
done
