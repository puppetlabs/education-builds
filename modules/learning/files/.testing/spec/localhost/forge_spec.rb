require 'spec_helper'


describe "The installed modules" do 
  it 'should be listed as a tree' do
    file('/root/.bash_history').should contain "puppet module list --tree"
  end
end

describe "The Forge" do
  it 'should be search for mysql modules' do
    file('/root/.bash_history').should contain "puppet module search mysql"
  end
end

describe "Version 2.2.2 of the puppetlabs-mysql module" do
  it 'should be installed' do
    file('/root/.bash_history').should contain "puppet module install puppetlabs-mysql --version 2.2.2"
  end
end

describe 'The puppetlabs-mysql module' do
  it 'should be upgraded' do
    file('/root/.bash_history').should contain "puppet module upgrade puppetlabs-mysql"
  end
end
