#! /bin/sh

PASSWORD=$(openssl rand -base64 6)
echo ${PASSWORD} | passwd --stdin root > /dev/null

[[ $? -ne 0 ]] && exit 1

# if we got here, then we've successfully changed the password
echo ${PASSWORD}

# remove ourself so it's a one time shot
rm $(readlink -f $0)

