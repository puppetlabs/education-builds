#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

if hosts_as('learning').length > 0
  describe file('/root/learning.answers') do
    it { should be_file }
    it { should contain('q_puppetagent_certname=learn.localdomain') }
  end
  describe file('/etc/motd') do
    it { should be_file }
    it { should contain('Password: learningpuppet') }
  end
  describe package('tmux') do
    it { should be_installed }
  end
  describe file('/root/README') do
    it { should be_file }
    it { should contain('Puppet Enterprise Learning VM') }
  end
  describe file('/root/bin') do
    it { should be_directory }
  end
  describe file('/root/.tmux.conf') do
    it { should be_file }
    it { should contain("set-option -g status-right 'Quest:") }
  end
  describe file('/root/.testing/spec/localhost/begin_spec.rb') do
    it { should be_file }
    it { should contain("require 'spec_helper'") }
  end
  describe file('/root/.testing/log.yml') do
    it { should be_file }
    it { should contain('current: begin') }
  end
  describe file('/root/.testing/test.rb') do
    it { should be_mode 755 }
  end
  describe file('/root/setup/guide.pp') do
    it { should contain('/var/www/html') }
  end
  describe file('/opt/puppet/bin/puppet') do
    it { should be_file }
    it { should be_mode 755 }
  end
  describe file('/root/examples') do
    it { should be_directory }
  end
  describe 'learning VM gems' do
    it 'should be installed' do
      shell("/opt/puppet/bin/gem list trollop -i") do |cmd|
        cmd.exit_code.should == 0
      end
      shell("/opt/puppet/bin/gem list serverspec -i") do |cmd|
        cmd.exit_code.should == 0
      end
    end
  end
end
