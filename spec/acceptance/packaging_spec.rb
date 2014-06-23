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
describe host('localhost.localdomain') do
    it { should be_resolvable.by('hosts') }
end
describe file('/etc/puppet/ssl') do
  it {should_not be_directory }
end
describe file('/etc/ssh/sshd_config') do
  it { should contain('^GSSAPIAuthentication no') }
end

#cached_modules = ['puppetlabs-concat-1.0.0.tar.gz', 'cprice404-inifile-0.10.4.tar.gz']
cached_modules = [
  'puppetlabs-concat', 
  'camptocamp-augeasfacter',
  'domcleal-augeasproviders',
  'razorsedge-vmwaretools',
  'hunner-wordpress',
  'puppetlabs-mysql',
  'puppetlabs-apache',
  'thias-vsftpd',
  'puppetlabs-vcsrepo',
  'puppetlabs-ntp',
  'puppetlabs-haproxy',
  'jamtur01-irc',
  'hunner-charybdis',
  'puppetlabs-puppetdb',
  'puppetlabs-pe_gem',
  'stahnma-epel',
  'nanliu-staging'
  ]

# Just check that they are present
# functional tests elsewhere will determine whether the cached version work.
# This way we can always cache latest and run (functional) tests against them
describe 'Forge Modules' do
  it 'should be cached' do
    cached_modules.each do |mod|
      expect(shell('ls /usr/src/forge').stdout).to match /#{mod}/
      expect(shell("file /usr/src/forge/#{mod}*.tar.gz").stdout).to match /HTML/#/gzip compressed data/
    end
  end
end

describe 'Puppetlabs yumrepo' do
  it 'should be disabled' do
    expect(shell('yum repolist disabled').stdout).to match /puppetlabs/     
  end
end
# Learning VM specific stuff:
if hosts_as('learning').length > 0
end

# Training VM specific stuff below:
if hosts_as('training').length > 0
  describe file('/root/.ssh_keygen.sh') do
    it { should be_mode 755 }
  end
end
