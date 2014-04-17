require 'spec_helper'

describe "The file /root/conditionals.txt" do
  it 'should exist and contain your Uptime' do
    file('/root/conditionals.txt').should contain 'Uptime is'
  end
end

describe "Facter" do
  it 'should be used to find your uptime in hours' do
    file('/root/.bash_history').should contain 'facter uptime_hours'
  end
end

describe "The file /root/case.txt" do
  it 'should contain your Apache package name' do
    file('/root/case.txt').should contain "Apache package name: httpd"
  end
end

describe "The file /root/architecture.txt" do
  it 'should contain your architecture' do
    file('/root/architecture.txt').should contain "This machine has a 32-bit architecture"
  end
end

