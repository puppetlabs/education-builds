# Zero out the free space to save space in the final image:
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Drop and recreate swap to reduce size

# Stop all PE processes to free up memory
for s in `find /etc/init.d/ -name pe* -type f -printf "%f\n"`
do
  service $s stop
done

swapoff -a
dd if=/dev/zero of=/swapfile bs=1M count=4096
mkswap /swapfile
