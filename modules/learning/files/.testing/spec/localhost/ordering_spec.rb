require 'spec_helper'


describe "The file /root/sshd.pp" do
  it 'should be created' do
    file('/root/sshd.pp').should contain "source => '/root/examples/sshd_config'"
  end
end

describe "GSSAPIAuthentication" do
  it 'should be disable in the sshd config file' do
    file('/etc/ssh/sshd_config').should contain /^GSSAPIAuthentication no/
  end
end

describe "The file /root/sshd.pp" do
  it 'should contain a package declaration' do
    file('/root/sshd.pp').should contain /package {/
  end
end
