Puppet::Parser::Functions.newfunction(:dirnames, :type => :rvalue, :doc => <<-EOS
This function accepts an array of filenames and strips the filename from each.
from the resulting array.

EOS
  ) do |args|

  unless args[0].is_a?(Array)
    raise Puppet::ParseError, "dirnames(): expected an Array, got #{args[0].inspect}"
  end

  args[0].collect do |file|
    File.dirname(file)
  end
end
