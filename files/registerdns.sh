#!/bin/bash

## If a file called dnsconfig.sh exists in /boot (put there by the
## ship rake task), source it
## and use the variables to set dynamic DNS registration
## information, grab the puppetlabs public keys for root's 
## authorized_keys file, then delete dnsconfig.sh and this file. If it doesn't
## exist, then just delete this script and exit.

## This is intended to support publishing the learning VM
## to our local VMware environment without changing the
## config for end-users. 

get_ssh_keys ()
{ 

## This is the manage_root_authorized_keys script from puppetlabs-sshkeys

set -u

# MAKE SURE THIS IS SSL!
URL="https://raw.github.com/puppetlabs/puppetlabs-sshkeys/master/templates/ssh/authorized_keys"

if [[ `uname` == CYGWIN* ]]
    then
    OWNER="Administrator"
    GROUP="None"
    SSH_HOME=~Administrator/.ssh/
else
    OWNER="0"
    GROUP="0"
    SSH_HOME=~root/.ssh/
fi

if which curl 2>&1 >/dev/null
    then
    GET="curl --silent -o - ${URL}"
else
    GET="wget -q -O - ${URL}"
fi

if ! [[ -d $SSH_HOME ]]
    then
    mkdir $SSH_HOME
    chmod 700 $SSH_HOME
    chown $OWNER:$GROUP $SSH_HOME
fi

# Make sure there is no temporary file
if [[ -f $SSH_HOME/authorized_keys.tmp ]]
    then
    rm -f $SSH_HOME/authorized_keys.tmp
fi

# This should be gone now.
if ! [[ -f $SSH_HOME/authorized_keys.tmp ]]
    then
    touch $SSH_HOME/authorized_keys.tmp
    chmod 644 $SSH_HOME/authorized_keys.tmp
    chown $OWNER:$GROUP $SSH_HOME/authorized_keys.tmp
fi

# Download the file.  Abort without modifying ~/.ssh/authorized_keys if this
# step fails.
$GET > $SSH_HOME/authorized_keys.tmp
rval=$?
if [[ $rval -ne 0 ]]; then
    echo "Error: Download failed with exit status code $rval"
    exit 1
fi

# Merge any local authorized_keys
# Make sure there is no temporary file
if [[ -f $SSH_HOME/authorized_keys.local ]]
    then
    cp -p $SSH_HOME/authorized_keys.{tmp,downloaded}
    cat $SSH_HOME/authorized_keys.{local,downloaded} | sort | uniq > $SSH_HOME/authorized_keys.tmp
fi

# Now move the file into place.  POSIX rename is atomic.
mv -f $SSH_HOME/authorized_keys.tmp $SSH_HOME/authorized_keys

}


me=$(readlink -f $0)

if [ -f /boot/dnsconfig.sh ]; then
    . /boot/dnsconfig.sh
    yum install -y open-vm-tools
    echo "DHCP_HOSTNAME=$dhcp_hostname" >> /etc/sysconfig/network-scripts/ifcfg-eth0
    get_ssh_keys
    rm /boot/dnsconfig.sh
    rm $me
    /sbin/reboot    
else
    rm $me
fi