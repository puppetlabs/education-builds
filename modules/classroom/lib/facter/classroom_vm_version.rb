Facter.add('classroom_vm_release') do
  setcode do
    case Facter.value(:osfamily)
    when 'windows'
      path = 'C:\\puppetlabs-release'
    else
      path = '/etc/puppetlabs-release'
    end
    next unless File.file? path

    version = File.read(path).match(/Puppet Labs Training VM (\d+\.\d+) .*$/)
    version[1] if version
  end
end
