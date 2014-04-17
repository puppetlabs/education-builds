require 'spec_helper'


describe "Find the modulepath" do 
  it 'using puppet agent --configprint' do
    file('/root/.bash_history').should contain "puppet agent --configprint modulepath"
  end
end

describe "The directory for the new users module" do
  it 'should be created' do
    file('/etc/puppetlabs/puppet/modules/users').should be_directory
  end
end

describe "The directories for manifests and tests" do
  it 'should be created' do
    file('/etc/puppetlabs/puppet/modules/users/manifests').should be_directory
    file('/etc/puppetlabs/puppet/modules/users/tests').should be_directory
  end
end

describe 'The manifest with the users class' do
  it 'should be created' do
    file('/etc/puppetlabs/puppet/modules/users/manifests/init.pp').should contain 'class users'
  end
end

describe 'The test manifest for the users class' do
  it 'should be created' do
    file('/etc/puppetlabs/puppet/modules/users/tests/init.pp').should contain 'include users'
  end
end


