require 'spec_helper'

describe "The file /root/pangrams/fox.txt" do
  it 'should contain a pangram' do
    file('/root/pangrams/fox.txt').should contain 'The quick brown fox jumps over the lazy dog'
  end
end

describe "The file /root/pangrams/perfect_pangrams/bortz.txt" do
  it 'should contain a perfect pangram' do
    file('/root/pangrams/perfect_pangrams/bortz.txt').should contain 'Bortz waqf glyphs vex muck djin'
  end
end

describe "The file /root/message.txt" do
  it 'should contain your OS Family and Uptime' do
    file('/root/message.txt').should contain "Hi, I'm a RedHat system and I have been up for"
  end
end
