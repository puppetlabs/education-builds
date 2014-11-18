source ./setup_environment.sh
# You know what sucks about this (other than it's a shell script)? No caching.
# This script is going to try and download the PE tarball EVERY TIME YOU RUN IT.
# That sucks, but I've not yet thought of a way to manage that (YET).

# If we're using the latest version of PE, get the real version string out
# of the LATEST symlink. If we're NOT, use the version specified.


if [ "${PE_STATUS}" == 'latest' ]
then
  IFS='. ' read -a VERSION <<< $PE_VERSION
  REAL_VERSION=`curl http://neptune.delivery.puppetlabs.net/"${VERSION[0]}"."${VERSION[1]}"/ci-ready/LATEST`
  PE_TARBALL="puppet-enterprise-${REAL_VERSION}-el-6-i386.tar"
  PEAGENT_TARBALL="puppet-enterprise-${REAL_VERSION}-el-6-i386-agent.tar.gz"
  URL_PREFIX="http://neptune.delivery.puppetlabs.net/${VERSION[0]}.${VERSION[1]}/ci-ready"
else
  REAL_VERSION=$PE_VERSION
  PE_TARBALL="puppet-enterprise-${REAL_VERSION}-el-6-i386.tar.gz"
  PEAGENT_TARBALL="puppet-enterprise-${REAL_VERSION}-el-6-i386-agent.tar.gz"
  URL_PREFIX="https://s3.amazonaws.com/pe-builds/released/${REAL_VERSION}"
fi

# Assemble the full URL, change to /root, pull down the tarball
URL="${URL_PREFIX}/${PE_TARBALL}"
AGENT_URL="${URL_PREFIX}/${PEAGENT_TARBALL}"
echo "cd /root"
cd /root
# Only download if there aren't cached copies
if [ -a "/tmp/${PE_TARBALL}" ] && [ -a "/tmp/${PEAGENT_TARBALL}" ]
then
  mv "/tmp/${PE_TARBALL}" "/root/${PE_TARBALL}"
  mv "/tmp/${PEAGENT_TARBALL}" "/usr/src/installer/${PEAGENT_TARBALL}"
else
  echo "curl -o ${PE_TARBALL} ${URL}"
  curl -o "${PE_TARBALL}" "${URL}"
  echo "curl -o ${PEAGENT_TARBALL} ${AGENT_URL}"
  curl -o "${PEAGENT_TARBALL}" "${AGENT_URL}"
fi

# Assuming that the installer is either a tar or a tar.gz
if [ "${VM_TYPE}" == 'learning' ]
then
  case "$PE_TARBALL" in
    *.tar.gz) tar zxmf "$PE_TARBALL" ;;
    *.tar)    tar xmf "$PE_TARBALL" ;;
  esac
  if [ "${PE_TARBALL##*.}" == 'gz' ]
  then
    ln -s /root/"${PE_TARBALL%.tar.gz}" /root/puppet-enterprise
  else
    ln -s /root/"${PE_TARBALL%.tar}" /root/puppet-enterprise
  fi
fi
