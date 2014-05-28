#! /bin/sh

if (( $# != 1 )); then
  echo "Call this script with the name of the environment"
  echo "Example: ${0} production"
  exit 1
fi

ENVROOT='/etc/puppetlabs/puppet/environments'
GITDIR="${ENVROOT}/${1}/.git"

git --git-dir ${GITDIR} rev-parse --short HEAD
