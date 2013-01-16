Facter.add('peversion') do
  setcode do
    begin
      require 'puppet'
      puppetversion = Puppet::PUPPETVERSION.to_s
    rescue LoadError
      nil
    end
      Regexp.last_match[1] if puppetversion =~ /^\S{2,}\s\(Puppet\sEnterprise\s(\S{2,})\)/
  end
end
