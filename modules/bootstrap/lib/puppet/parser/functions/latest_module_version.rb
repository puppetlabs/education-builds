require 'puppet/forge'

module Puppet::Parser::Functions
  newfunction(:latest_module_version, :type => :rvalue, :arity=> 2, :doc => <<-EOS
    Returns latest version number for a module.
    Requires exactly two inputs - the author's name and the module's name 
    in that order.
    Usage example: 
      latest_module_version(('puppetlabs', 'mysql')
    EOS
) do |args|
    name = "#{args[0]}/#{args[1]}"  
    forge = Puppet::Forge.new
    forge.search(name).first['version']
  end
end
