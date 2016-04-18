#! /bin/bash

BUILD_ROOT_DIR=${BUILD_ROOT_DIR:-.}
VAGRANT_BOX_NAME=${VAGRANT_BOX_NAME:-centos-7.2-x86_64-vmware-nocm-1.0.1.box}
VAGRANT_BASE_URL=${VAGRANT_BASE_URL:-http://int-resources.ops.puppetlabs.net/Vagrant%20images}

## Set up default cache directories
echo Setting up default directories
if [ ! -d $BUILD_ROOT_DIR/file_cache ]; then
    mkdir $BUILD_ROOT_DIR/file_cache
fi
if [ ! -d $BUILD_ROOT_DIR/output ]; then
    mkdir $BUILD_ROOT_DIR/output
fi
if [ ! -d $BUILD_ROOT_DIR/output/education-base-vmware ]; then
    mkdir $BUILD_ROOT_DIR/output/education-base-vmware
fi
if [ ! -d $BUILD_ROOT_DIR/packer_cache ]; then
    mkdir $BUILD_ROOT_DIR/packer_cache
fi

echo Downloading base image
cd output/education-base-vmware
curl -O $VAGRANT_BASE_URL/$VAGRANT_BOX_NAME 
tar xzvf $VAGRANT_BOX_NAME
mv *.vmx education-base.vmx

