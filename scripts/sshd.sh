#!/bin/bash -eux

echo "UseDNS no" | sudo tee -a /etc/ssh/sshd_config
echo "GSSAPIAuthentication no" | sudo tee -a /etc/ssh/sshd_config
