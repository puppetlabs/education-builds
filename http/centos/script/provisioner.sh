#!/bin/sh -eux

# Set $PROVISIONER
#
# Valid values for $PROVISIONER are:
#   'nocm'   -- build a box without a provisioner
#   'puppet' -- build a box with the Puppet provisioner
#
REPO_URL="http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm"

if [ "${PROVISIONER}" == 'puppet' ]; then
  if which puppet > /dev/null 2>&1; then
    echo "Puppet is already installed."
    exit 0
  fi

  # Install puppet labs repo
  echo "Configuring PuppetLabs repo..."
  repo_path=$(mktemp)
  wget --output-document="${repo_path}" "${REPO_URL}" 2>/dev/null
  rpm -i "${repo_path}" >/dev/null

  # Install Puppet...
  echo "Installing puppet"
  yum install -y puppet > /dev/null

  echo "Puppet installed!"
else
  echo "Building a box without a provisioner"
fi
