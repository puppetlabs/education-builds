require 'spec_helper'


describe "The /root/examples/modules1-ntp1.pp manifest" do
  it 'should be applied' do
    file('/root/.bash_history').should contain "puppet apply /root/examples/modules1-ntp1.pp"
  end
end

describe "The /root/examples/modules1-ntp2.pp manifest" do
  it 'should be applied to declare class ntp' do
    file('/root/.bash_history').should contain "puppet apply /root/examples/modules1-ntp2.pp"
  end
end
