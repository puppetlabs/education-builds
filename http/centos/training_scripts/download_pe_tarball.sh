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
  URL_PREFIX="http://neptune.delivery.puppetlabs.net/#{VERSION[0]}.#{VERSION[1]}/ci-ready"
else
  REAL_VERSION=$PE_VERSION
  PE_TARBALL="puppet-enterprise-${REAL_VERSION}-el-6-i386.tar.gz"
  URL_PREFIX="https://s3.amazonaws.com/pe-builds/released/${REAL_VERSION}"
fi

# Assemble the full URL, change to /root, pull down the tarball, and expand
# to the 'puppet-enterprise' directory.
URL="${URL_PREFIX}/${PE_TARBALL}"
echo "cd /root"
cd /root
echo "curl -o ${PE_TARBALL} ${URL}"
curl -o "${PE_TARBALL}" "${URL}"
