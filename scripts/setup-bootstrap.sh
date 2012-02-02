#!/bin/sh

set -e
set -u
#set -x

## Define helper functions {{{1
#
# Bailout function for errors {{{2
#
function bail () { echo $1; exit 1; }

# Curl function for downloading files {{{2
#
function download () {
    ## Usage: download <source> <destination>
    source=$1
    destination=$2
    [[ ! -f $destination ]] && (curl -#o $destination $source || bail "Cannot curl ${source}")
    true
}
# 2}}}

# Git clone/pull function {{{2
#
function gitclone () {
    ## Usage: clone <source> <destination>
    source=$1
    destination=$2
    branch=$3
    [[ ! -d $destination ]] \
        && (git clone --bare $source $destination && cd $destination && git update-server-info && git symbolic-ref HEAD refs/heads/$branch || bail "Cannot clone ${source}") \
        || (cd $destination && (git fetch origin '+refs/heads/*:refs/heads/*' && git update-server-info && git symbolic-ref HEAD refs/heads/$branch || bail "Cannot pull ${source}"))
}


## Set up the directory variables {{{1
#
datadir="${HOME}/Sites/ks"
mountdir="${HOME}/Sites/dvd"
repodir="`dirname $0`/.."
echo "Creating directories..."
[[ ! -d $datadir ]] && (mkdir $datadir || bail "Cannot create ${datadir}")
[[ ! -d $mountdir ]] && (mkdir $mountdir || bail "Cannot create ${mountdir}")


## Download files to 'data' {{{1
#
# Download epel rpm {{{2
#
echo "Downloading epel..."
download \
    http://mirrors.cat.pdx.edu/epel/5/i386/epel-release-5-4.noarch.rpm \
    ${datadir}/epel-release-5-4.noarch.rpm

# Download PE tarball {{{2
#
echo "Downloading PE..."
download \
    https://pm.puppetlabs.com/puppet-enterprise/2.0.1/puppet-enterprise-2.0.1-el-5-i386.tar.gz \
    ${datadir}/puppet-enterprise-2.0.1-el-5-i386.tar.gz
# 2}}}


## Clone repos to 'data' {{{1
#
echo "Cloning puppet..." # {{{2
gitclone \
    git://github.com/puppetlabs/puppet.git \
    ${datadir}/puppet.git \
    master
echo "Cloning facter..." # {{{2
gitclone \
    git://github.com/puppetlabs/facter.git \
    ${datadir}/facter.git \
    master
echo "Cloning mcollective..." # {{{2
gitclone \
    git://github.com/puppetlabs/marionette-collective.git \
    ${datadir}/mcollective.git \
    master

# Set PTB settings {{{2
ptbrepo_destination=${datadir}/puppetlabs-training-bootstrap.git

# Set PTB repo {{{3
if [[ -f ${ptbrepo_destination}/config ]] ; then
  ptbrepo_default=`grep "url = " ${ptbrepo_destination}/config | sed 's/.*url = //'`
  ptbrepo=$ptbrepo_default
  echo "Current repo url: ${ptbrepo_default} (\`rm\` local repo to reset)"
else
  # Set PTB user
  echo "Please choose a github user for puppetlabs-training-bootstrap [puppetlabs]: \c"
  read ptbuser
  if [[ -z $ptbuser ]] ; then ptbuser="puppetlabs" ; fi

  ptbrepo_default="git@github.com:${ptbuser}/puppetlabs-training-bootstrap.git"
  echo "Modify repo url [${ptbrepo_default}]: \c"
  read ptbrepo
fi
if [[ -z $ptbrepo ]] ; then ptbrepo=$ptbrepo_default ; fi

# Set PTB branch {{{2
if [[ -f ${ptbrepo_destination}/HEAD ]] ; then
  ptbbranch_default=`sed 's/.*refs\/heads\///' ${ptbrepo_destination}/HEAD`
else
  ptbbranch_default='master'
fi
echo "Please choose a branch to use for puppetlabs-training-bootstrap [${ptbbranch_default}]: \c"
read ptbbranch
if [[ -z $ptbbranch ]] ; then ptbbranch=$ptbbranch_default ; fi
echo "Cloning ptb..." # {{{2
gitclone \
    $ptbrepo \
    $ptbrepo_destination \
    $ptbbranch


## Mount ~/Sites/dvd from centos DVD {{{1
#
if [[ ! -f ${mountdir}/GPL ]] ; then
    echo "Please enter the path to CentOS DVD iso (drag 'n drop): \c"
    read cdrompath
    hdiutil attach -mountpoint $mountdir $cdrompath || bail "Cannot mount ${cdrompath}"
else
    echo "$mountdir is already mounted; skipping"
fi


## Enable PHP for kickstart file {{{1
#
if `grep '#LoadModule php5_module' /private/etc/apache2/httpd.conf > /dev/null` ; then
    echo "Enabling php... (requires sudo)"
    sudo sed -i -e 's^#LoadModule php5_module.*libexec/apache2/libphp5.so^LoadModule php5_module libexec/apache2/libphp5.so^' /private/etc/apache2/httpd.conf || bail "Cannot enable php"
    sudo apachectl restart || bail "Cannot restart apache"
else
    echo "PHP already enabled... (skipping)"
fi
echo "Copying centos.php..."
cp ${repodir}/files/centos.php ${datadir}
