require 'spec_helper'

describe "The file /root/byte.pp" do
  it 'should be created' do
    file('/root/byte.pp').should be_file
    file('/root/byte.pp').should contain /ensure => 'absent'/
  end
end

describe "The puppet parser command" do
  it 'should be used to check syntax' do
    file('/root/.bash_history').content.should match /^puppet parser validate \/?(\w*\/)*byte.pp\s*/
  end
end

describe "The byte.pp manifest" do
  it 'should be simulated using the --noop flag' do
    file('/root/.bash_history').content.should match /^puppet apply --noop \/?(\w*\/)*byte.pp\s*/
  end
end

describe "The byte.pp manifest" do
  it 'should be applied' do
    file('/root/.bash_history').content.should should match /^puppet apply \/?(\w*\/)*byte.pp\s*/
  end
end

describe "The user gigabyte" do
  it 'should be created' do
    user('gigabyte').should exist
  end
end

