require 'spec_helper'

describe "useradd ralph" do
  it 'should be executed' do
    file('/root/.bash_history').should contain "useradd ralph"
  end
end

describe "puppet resource user ralph" do
  it 'should be executed' do
    file('/root/.bash_history').should contain 'puppet resource user ralph'
  end
end

describe "passwd ralph" do
  it 'should be executed' do
    file('/root/.bash_history').should contain 'passwd ralph'
  end
end

describe "puppet resource file /home/ralph/spells" do
  it 'should be executed' do
    file('/root/.bash_history').should contain 'puppet resource file /home/ralph/spells'
  end
end

describe "mkdir /home/ralph/spells" do
  it 'should be executed' do
    file('/root/.bash_history').should contain 'mkdir /home/ralph/spells'
  end
end

describe "chmod 700 /home/ralph/spells" do
  it 'should be executed' do
    file('/root/.bash_history').should contain 'chmod 700 /home/ralph/spells'
  end
end

