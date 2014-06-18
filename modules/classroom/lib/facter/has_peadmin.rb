Facter.add('has_peadmin') do
  setcode do
    File.directory?('/var/lib/peadmin')
  end
end
