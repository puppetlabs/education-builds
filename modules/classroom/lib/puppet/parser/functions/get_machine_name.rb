
module Puppet::Parser::Functions
  newfunction(:get_machine_name, :type => :rvalue, :arity=> 1, :doc => <<-EOS
    Returns the machine hostname from a fully qualified domain name.
    Usage example: 
      get_machine_name('examplestudent.puppetlabs.vm)
    EOS
  ) do |args|
    args[0].split('.')[0]
  end
end
