rm -f /root/.bash_history
rm -f /root/.viminfo
echo > /var/log/lastlog

# are we an interactive shell?
if [ "$PS1" ]; then
  # shut down the machine for garbage collection
  shutdown -h now
fi
