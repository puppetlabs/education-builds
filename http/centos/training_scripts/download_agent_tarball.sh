# You know what sucks about this (other than it's a shell script)? No caching.
# This script is going to try and download the PE tarball EVERY TIME YOU RUN IT.
# That sucks, but I've not yet thought of a way to manage that (YET).

# If we're using the latest version of PE, get the real version string out
# of the LATEST symlink. If we're NOT, use the version specified.
if [ "${PE_STATUS}" == 'latest' ]
then
  IFS='. ' read -a VERSION <<< $PE_VERSION
  REAL_VERSION=`curl http://neptune.delivery.puppetlabs.net/"${VERSION[0]}"."${VERSION[1]}"/ci-ready/LATEST`
  PE_AGENT_TARBALL="puppet-enterprise-${REAL_VERSION}-el-6-i386-agent.tar.gz"
  AGENT_URL_PREFIX="http://neptune.delivery.puppetlabs.net/#{VERSION[0]}.#{VERSION[1]}/ci-ready"
else
  REAL_VERSION=$PE_VERSION
  PE_AGENT_TARBALL="puppet-enterprise-${REAL_VERSION}-el-6-i386-agent.tar.gz"
  AGENT_URL_PREFIX="https://s3.amazonaws.com/pe-builds/released/${REAL_VERSION}"
fi

# Assemble the full URL, change to /usr/src/installer, pull down the tarball
URL="${AGENT_URL_PREFIX}/${PE_AGENT_TARBALL}"
echo "create /usr/src/installer/${REAL_VERSION}/ and cd there"
mkdir -p /usr/src/installer/${REAL_VERSION}; cd /usr/src/installer/${REAL_VERSION}/
echo "curl -o ${PE_AGENT_TARBALL} ${URL}"
curl -o "${PE_AGENT_TARBALL}" "${URL}"
