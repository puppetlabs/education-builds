Facter.add('root_ssh_key') do
  setcode do
    pubkey = '/root/.ssh/id_rsa.pub'
    File.read(pubkey).split[1] if File.exists? pubkey
  end
end

