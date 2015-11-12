#!/bin/bash
# If the centos user doesn't exsit, add the insecure vagrant public key
# and add the user to the sudoers group
# This is horribly insecure, don't ever use this on a production machine

if ! grep centos /etc/passwd
then
  adduser centos
  echo "centos  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
  mkdir -p /home/centos/.ssh/
  curl https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub >> /home/centos/.ssh/authorized_keys
  chown -R centos:centos /home/centos/.ssh/
  chmod 0600 /home/centos/.ssh/authorized_keys
fi
