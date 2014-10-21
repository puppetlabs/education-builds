Facter.add('has_hocon') do
  setcode do
    # cries a little
    begin
      require 'hocon'
      true
    rescue LoadError
      false
    end
  end
end
