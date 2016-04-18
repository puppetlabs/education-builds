#! /bin/bash

BUILD_ROOT_DIR=${BUILD_ROOT_DIR:-`pwd`}
EDUCATION_VAGRANT_BOX_NAME=${VAGRANT_BOX_NAME:-centos-7.2-x86_64-vmware-nocm-1.0.1.box}
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

function get_vm {
  IMAGE_TYPE=$1
  IMAGE_NAME=`echo $IMAGE_TYPE | awk '{print toupper($0)}'`
  IMAGE_BOX=${IMAGE_NAME}_VAGRANT_BOX_NAME
  
  rm -rf $BUILD_ROOT_DIR/output/$IMAGE_TYPE-base-vmware
  mkdir $BUILD_ROOT_DIR/output/$IMAGE_TYPE-base-vmware
  cd $BUILD_ROOT_DIR/output/

  if [ ! -s  ${!IMAGE_BOX} ]; then
    echo Downloading ${!IMAGE_BOX} base image
    curl $VAGRANT_BASE_URL/${!IMAGE_BOX} -o ${!IMAGE_BOX}
  fi
  
  mv ${!IMAGE_BOX} $IMAGE_TYPE-base-vmware/
  cd $BUILD_ROOT_DIR/output/$IMAGE_TYPE-base-vmware
  tar xzvf ${!IMAGE_BOX}
  mv *.vmx $IMAGE_TYPE-base.vmx

  echo Converting to single disk
  vmware-vdiskmanager -r disk-cl1.vmdk -t 0 disk-cl1.vmdk.temp
  rm -rf disk-cl1*vmdk
  mv disk-cl1.vmdk.temp disk-cl1.vmdk

  mv ${!IMAGE_BOX} $BUILD_ROOT_DIR/output/
  cd $BUILD_ROOT_DIR
}

get_vm education
get_vm student
