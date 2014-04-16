require 'spec_helper'

describe file('/root/ralph.pp') do
  it { should exist }
  it { should contain "ensure => 'absent'" }
end

describe "puppet parser validate ralph.pp" do
  it 'should be executed' do
    file('/root/.bash_history').should contain 'puppet parser validate ralph.pp'
  end
end

describe "puppet apply --noop ralph.pp" do
  it 'should be executed' do
    file('/root/.bash_history').should contain 'puppet apply --noop ralph.pp'
  end
end

describe "puppet apply ralph.pp" do
  it 'should be executed' do
    file('/root/.bash_history').should contain 'puppet apply ralph.pp'
  end
end

describe "puppet resource user ralph" do
  it 'should be executed' do
    file('/root/.bash_history').should contain 'puppet resources user ralph'
  end
end

describe file('/root/jack.pp') do
  it { should exist }
  it { should contain "ensure => 'present'" }
end


describe "puppet parser validate jack.pp" do
  it 'should be executed' do
    file('/root/.bash_history').should contain 'puppet parser validate jack.pp'
  end
end


describe "puppet apply --noop jack.pp" do
  it 'should be executed' do
    file('/root/.bash_history').should contain 'puppet apply --noop jack.pp'
  end
end

describe "puppet apply jack.pp" do
  it 'should be executed' do
    file('/root/.bash_history').should contain 'puppet apply jack.pp'
  end
end


describe "puppet resource user jack" do
  it 'should be executed' do
    file('/root/.bash_history').should contain 'puppet resources user jack'
  end
end
