require 'spec_helper'

describe "The puppet describe command" do
  it 'should be used to learn about the user resource type' do
    file('/root/.bash_history').should contain "puppet describe user"
  end
end

describe "The puppet resource command" do
  it 'should be used to inspect user root' do
    file('/root/.bash_history').should contain 'puppet resource user root'
  end
end

describe "user byte" do
  it 'should be created' do
    user('byte').should exist
  end
end

describe "The puppet resource command" do
  it 'should be used to inspect user byte' do
    file('/root/.bash_history').should contain 'puppet resource user byte'
  end
end

describe "user byte's password" do
  it 'should be changed' do
    file('/root/.bash_history').should contain 'passwd byte'
  end
end

describe "The diretory /home/byte/tools" do
  it "should be created" do
    file('/root/.bash_history').should be_directory
  end
end

describe "The directory /home/byte/tools" do
  it 'should be owned by byte new' do
    file('/home/byte/tools').should be_owned_by 'byte'
    file('/home/byte/tools').should be_grouped_into 'byte'
  end
end
