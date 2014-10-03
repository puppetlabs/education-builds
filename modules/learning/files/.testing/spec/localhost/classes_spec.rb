require 'spec_helper'


oescribe "The /root/examples/modules1-ntp1.pp manifest" do
  it 'should be applied' do
    file('/root/.bash_history').content.should match /^puppet apply \/?(\w*\/)*modules1-ntp1.pp\s*/ 
  end
end

describe "The /root/examples/modules1-ntp2.pp manifest" do
  it 'should be applied to declare class ntp' do
    file('/root/.bash_history').content.should match /^puppet apply \/?(\w*\/)*modules1-ntp2.pp\s*/
  end
end
