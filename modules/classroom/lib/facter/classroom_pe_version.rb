Facter.add('classroom_pe_version') do
  setcode do
    pe_ver = Facter.value("puppetversion").match(/Puppet Enterprise (\d+\.\d+\.\d+)/)
    pe_ver[1] if pe_ver
  end
end
