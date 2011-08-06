#!/bin/sh

set -e
set -x
set -u

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
    [[ ! -f $destination ]] \
        && curl -so $destination $source \
        || bail "Cannot curl ${source}"
}
# 2}}}


## Set up the directory variables {{{1
#
datadir="${HOME}/Sites/data"
mountdir="${HOME}/Sites/dvd"
moduledir="`dirname $0`/../modules"
echo "Creating directories..."
[[ ! -d $datadir ]] && mkdir $datadir #|| bail "Cannot create ${datadir}"
[[ ! -d $mountdir ]] && mkdir $mountdir #|| bail "Cannot create ${mountdir}"


## Download files to 'data' {{{1
#
# Download epel rpm {{{2
#
echo "Downloading epel..."
download \
    http://mirrors.cat.pdx.edu/epel/5/x86_64/epel-release-5-4.noarch.rpm \
    ${datadir}/epel-release-5-4.noarch.rpm

# Download PE tarball {{{2
#
echo "Downloading PE..."
download \
    https://pm.puppetlabs.com/puppet-enterprise/1.1/puppet-enterprise-1.1-centos-5-x86_64.tar \
    ${moduledir}/pebase/files/puppet-enterprise-1.1-centos-5-x86_64.tar
# 2}}}


## Clone repos to 'data' {{{1
#
echo "Cloning puppet..."
git clone git://github.com/puppetlabs/puppet.git ${datadir}/puppet || bail "Cannot clone puppet"
echo "Cloning facter..."
git clone git://github.com/puppetlabs/facter.git ${datadir}/facter || bail "Cannot clone facter"
echo "Cloning mcollective..."
git clone git://github.com/puppetlabs/marionette-collective.git ${datadir}/mcollective || bail "Cannot clone mcollective"
echo "Cloning ptb..."
git clone git@github.com:puppetlabs/puppetlabs-training-bootstrap.git ${datadir}/puppetlabs-training-bootstrap || bail "Cannot clone ptb"


## Mount ~/Sites/dvd from centos DVD {{{1
#
echo -n "Please enter the path to CentOS DVD iso (drag 'n drop): "
read cdrompath
hdiutil attach -mountpoint $mountdir $cdrompath || bail "Cannot mount ${cdrompath}"


## Enable PHP for kickstart file {{{1
#
echo "Enabling php..."
sudo sed -i -e 's^#LoadModule php5_module libexec/apache2/libphp5.so^LoadModule php5_module libexec/apache2/libphp5.so^' /private/etc/apache2/httpd.conf || bail "Cannot enable php"
sudo apachectl restart || bail "Cannot restart apache"
