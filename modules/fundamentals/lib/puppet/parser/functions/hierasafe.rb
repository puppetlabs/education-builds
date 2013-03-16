module Puppet::Parser::Functions
  newfunction(:hierasafe, :type => :rvalue, :doc => 'Calls Hiera. Doesn\'t bomb when it\s not configured.') do |args|
    begin
      function_hiera(args)
    rescue Puppet::ParseError => e
      # Hiera must not be enabled on the master yet. Boo.
      notice('Hiera has not been configured on this master.')
      return false
    end
  end
end
