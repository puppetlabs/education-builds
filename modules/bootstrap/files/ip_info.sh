#/bin/sh
sleep 10
echo; echo "My IP information" >> /dev/tty1
/sbin/ifconfig  | grep "inet addr" >> /dev/tty1
