Facter.add('classroom_vm_release') do
  setcode do
    version = Facter::Util::Resolution.exec("cat /etc/puppetlabs-release").match(/Puppet Labs Training VM (\d.\d) .*$/)
    version[1] if version
  end
end
