# Stop all PE processes to free up memory
for s in `find /etc/init.d/ -name pe* -type f -printf "%f\n"`
do
  service $s stop
done

# Drop and recreate swap to reduce size
swapoff -a
dd if=/dev/zero of=/swapfile bs=1M count=4096
mkswap /swapfile

