require 'spec_helper'

describe "The version of Puppet" do
  it 'should be checked' do 
    file('/root/.bash_history').should contain 'puppet -V'
  end
end

describe "The options for the quest tool" do
  it 'should be explored' do
    file('/root/.bash_history').should contain "quest --help"
  end
end

describe "Quest progress" do
  it 'should be checked' do 
    file('/root/.bash_history').should contain "quest --progress"
  end
end
