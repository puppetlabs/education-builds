#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'PE installer' do
  it 'should be cached' do
    file('/root/puppet-enterprise').should be_directory
  end
end
describe 'Puppetlabs yumrepo' do
  it 'should be disabled' do
    expect(shell('yum repolist disabled').stdout).to match /puppetlabs/     
  end
end
#describe 'Local and remote CentOS yum repos' do
#  it 'should be enabled' do
#    on hosts, "yum repolist enabled" do |r|
#      expect(r.stdout).to match /^base\b/
#      expect(r.stdout).to match /^epel\b/
#      expect(r.stdout).to match /^extras\b/
#      expect(r.stdout).to match /^updates\b/
#      expect(r.stdout).to match /^base_local\b/
#      expect(r.stdout).to match /^epel_local\b/
#      expect(r.stdout).to match /^updates_local\b/
#    end
#  end
#end
#describe 'yum.conf' do
#   it 'should skip unavailable repos' do
#     file('/etc/yum.conf').should contain('skip_if_unavailable=1')
#   end
#end
describe file('/usr/bin/envpuppet') do
  it { should be_mode 755 }
end
describe file('/root/.ip_info.sh') do
  it { should be_mode 755 }
end
describe package('patch') do
  it {should be_installed }
end
describe package('screen') do
  it {should be_installed }
end
describe package('telnet') do
  it {should be_installed }
end
describe package('rubygems') do
  it {should be_installed }
end
describe package('tree') do
  it {should be_installed }
end
describe package('ruby-augeas') do
  it {should be_installed }
end
describe host('localhost.localdomain') do
    it { should be_resolvable.by('hosts') }
end
describe file('/etc/puppet/ssl') do
  it {should_not be_directory }
end
