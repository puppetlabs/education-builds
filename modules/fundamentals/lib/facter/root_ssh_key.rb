Facter.add('root_ssh_key') do
  setcode "cat /root/.ssh/id_rsa.pub | awk '{print $2}'"
end

