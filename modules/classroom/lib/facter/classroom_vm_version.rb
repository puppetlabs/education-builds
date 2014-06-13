Facter.add('classroom_vm_release') do
  setcode do
    version = File.read('/etc/puppetlabs-release').match(/Puppet Labs Training VM (\d.\d) .*$/)
    version[1] if version
  end
end
