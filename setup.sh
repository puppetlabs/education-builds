#! /bin/bash

BUILD_ROOT_DIR=${BUILD_ROOT_DIR:-`pwd`}
MAIN_VAGRANT_BOX_NAME=${VAGRANT_BOX_NAME:-centos-7.2-x86_64-vmware-nocm-1.0.1.box}
#Public download URL: https://atlas.hashicorp.com/puppetlabs/boxes/centos-7.2-64-nocm/versions/1.0.1/providers/vmware_desktop.box
STUDENT_VAGRANT_BOX_NAME=${VAGRANT_BOX_NAME:-centos-6.6-i386-vmware-nocm-1.0.3.box}
#Public download URL: https://atlas.hashicorp.com/puppetlabs/boxes/centos-6.6-32-nocm/versions/1.0.3/providers/vmware_desktop.box
VAGRANT_BASE_URL=${VAGRANT_BASE_URL:-http://int-resources.ops.puppetlabs.net/Vagrant%20images}

## Set up default cache directories
echo Setting up default directories
if [ ! -d $BUILD_ROOT_DIR/file_cache ]; then
    mkdir $BUILD_ROOT_DIR/file_cache
fi
if [ ! -d $BUILD_ROOT_DIR/output ]; then
    mkdir $BUILD_ROOT_DIR/output
fi
if [ ! -d $BUILD_ROOT_DIR/packer_cache ]; then
    mkdir $BUILD_ROOT_DIR/packer_cache
fi


echo Downloading main base image
rm -rf $BUILD_ROOT_DIR/output/education-base-vmware
mkdir $BUILD_ROOT_DIR/output/education-base-vmware
cd $BUILD_ROOT_DIR/output/education-base-vmware
curl $VAGRANT_BASE_URL/$MAIN_VAGRANT_BOX_NAME -o $MAIN_VAGRANT_BOX_NAME
tar xzvf $MAIN_VAGRANT_BOX_NAME
mv *.vmx education-base.vmx

cd $BUILD_ROOT_DIR

echo Downloading student base image
rm -rf $BUILD_ROOT_DIR/output/student-base-vmware
mkdir $BUILD_ROOT_DIR/output/student-base-vmware
cd $BUILD_ROOT_DIR/output/student-base-vmware
rm -f $BUILD_ROOT_DIR/output/student-base-vmware/*
curl $VAGRANT_BASE_URL/$STUDENT_VAGRANT_BOX_NAME -o $STUDENT_VAGRANT_BOX_NAME
tar xzvf $STUDENT_VAGRANT_BOX_NAME
mv *.vmx student-base.vmx
