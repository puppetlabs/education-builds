require 'spec_helper'

describe "Module puppetlabs-apache" do
  it 'should be installed' do 
    file('/etc/puppetlabs/puppet/modules/apache').should be_directory
    file('/etc/puppetlabs/puppet/modules/apache/Modulefile').should contain "name 'puppetlabs-apache'"
  end
end

describe "Facter should be used" do
  it 'to find the ipaddress' do
    file('/root/.bash_history').should contain "facter ipaddress"
  end
end

describe "The configuration changes" do
  it 'should be applied' do 
    file('/var/www/html/lvmguide/').should be_directory
    service('httpd').should be_running
  end
end
