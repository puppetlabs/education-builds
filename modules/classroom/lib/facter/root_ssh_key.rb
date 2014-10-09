Facter.add('root_ssh_key') do
  pubkey = '/root/.ssh/id_rsa.pub', 'C:/Users/Administrator/.ssh.pub'
  pubkey.each do |key|
    if File.exists? key
      setcode do
        File.read(key).split[1]
      end
    end
  end
end
