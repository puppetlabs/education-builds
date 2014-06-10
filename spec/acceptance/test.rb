#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

#if hosts_as('learning').length > 0

describe 'Quest tests' do
  it 'has the Welcome quest' do
    on hosts, "quest --start welcome" do |r|
      expect(r.exit_code).to eq(0)
      expect(r.stdout).to match /You have started the Welcome quest./      end
  end

  it 'has PE' do
    expect(shell('puppet -V').stdout).to match /Puppet Enterprise/
  end
end



hosts.each do |host|
  on host, "quest --start welcome" do 
    assert_equal(0, exit_code) 
    assert_match(/You have started the Welcome quest./, stdout)
  end

  on host, "puppet -V" do
    assert_equal(0, exit_code)
    assert_match(/Puppet Enterprise/, stdout)
  end

  on host, "quest --help" do
    assert_equal(0, exit_code)
    assert_match(/quest: learning progress feedback tool/, stdout)
  end

  on host, "quest --progress" do
    assert_equal(0, exit_code)
  end
end

hosts.each do |host|
  on host, "quest --start Power" do 
    assert_equal(0, exit_code) 
    assert_match(/You have started the Power quest./, stdout)
  end

  on host, "puppet -V" do
    assert_equal(0, exit_code)
    assert_match(/Puppet Enterprise/, stdout)
  end

  on host, "quest --help" do
    assert_equal(0, exit_code)
    assert_match(/quest: learning progress feedback tool/, stdout)
  end

  on host, "quest --progress" do
    assert_equal(0, exit_code)
  end
end

