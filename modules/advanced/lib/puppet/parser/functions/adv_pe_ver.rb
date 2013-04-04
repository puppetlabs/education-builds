module Puppet::Parser::Functions
  newfunction(:adv_pe_ver, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Returns the version number of Puppet Enterprise for a puppet agent, based on 
    the facter fact puppetversion, which exists on machines with Puppet Enterprise
    installed.
    This function takes no parameters
    ENDHEREDOC
    pe_ver = lookupvar('puppetversion').match(/Puppet Enterprise (\d+\.\d+\.\d+)/)
    pe_ver[1] if pe_ver
  end
end
