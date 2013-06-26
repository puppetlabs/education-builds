#!/bin/bash

# exit if the key is already generated
/usr/bin/test -f /root/.ssh/id_rsa && exit 0

/usr/bin/ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa 2>&1 > /dev/null
