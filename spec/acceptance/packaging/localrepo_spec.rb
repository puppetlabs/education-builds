#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'localrepos' do
  it 'should have packages cached' do
    shell('yum --disablerepo="*" --enablerepo="base_local" list available') do |cmd|
      cmd.stdout.should =~ /irssi/
      cmd.exit_code.should == 0
    end
    shell('yum --disablerepo="*" --enablerepo="epel_local" list available') do |cmd|
      cmd.stdout.should =~ /rubygem-sinatra/
      cmd.exit_code.should == 0
    end
    shell('yum --disablerepo="*" --enablerepo="updates_local" list available') do |cmd|
      cmd.exit_code.should == 0
    end
  end
end

