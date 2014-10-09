Facter.add('root_ssh_key') do
  pubkey = '/root/.ssh/id_rsa.pub', 'C:/Users/Administrator/.ssh.pub'
  pubkey.each do |key|
    setcode do
      File.read(key).split[1] if File.exists? key
    end
  end
end
