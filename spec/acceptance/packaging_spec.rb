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
      expect(shell("file /usr/src/forge/#{mod}*.tar.gz").stdout).to match /gzip compressed data/
    end
  end
end

describe 'Puppetlabs yumrepo' do
  it 'should be disabled' do
    expect(shell('yum repolist disabled').stdout).to match /puppetlabs/     
  end
end

describe file('/root/.gemrc') do
  it {should be_file }
end

cached_gems = [
  'builder',
  'addressable',
  'carrier-pigeon',
  'rack-protection',
  'sinatra',
  'tilt',
  'net-ssh',
  'highline',
  'serverspec',
  'trollop',
  'hiera-eyaml',
  'rspec',
  'diff-lcs',
  'rspec-core',
  'rspec-mocks',
  'rspec-puppet',
  'rspec-expectations',
  'mocha',
  'metaclass',
  'puppetlabs-spec-helper',
  'beaker',
  'beaker-rspec'
]

describe 'Gems' do
  it 'should be cached' do
    cached_gems.each do |gem|
      expect(shell('ls /var/cache/rubygems/gems').stdout).to match /#{gem}/
      expect(shell("file /var/cache/rubygems/gem/#{gem}*.gem").stdout).to match /POSIX tar archive/
    end
  end
end

describe file('/etc/shadow') do
  it { should contain('root:$1$hgIZHl1r$tEqMTzoXz.NBwtW3kFv33/') }
end

describe file('/root/.profile') do
  it { should contain('validate_yaml()') }
  it { should contain('validate_erb()') }
end

describe package('emacs') do
  it { should be_installed }
end

file ('/root/.emacs') do
  it { should contain('puppet-mode.el')
end

file ('/root/.emacs.d/puppet-mode.el') do
  it { should contain('puppet-mode-syntax-table')
end

describe package('vim-enhanced') do
  it { should be_installed }
end

describe file('/root/.vim') do
  it { should be_directory }
end

describe file('/root/.vim/syntax/puppet.vim') do
  it { should contain('puppet syntax file')
end

describe file('/root/.vimrc') do
  it { should contain('syntax on')
end

describe 'localrepos' do
  it 'should have packages cached' do
    shell("yum --disablerepo="*" --enablerepo="base_local" list available" do |cmd|
      cmd.stdout.should =~ /irssi/
      cmd.exit_code.should == 0
    end
    shell("yum --disablerepo="*" --enablerepo="epel_local" list available" do |cmd|
      cmd.stdout.should =~ /rubygem-sinatra/
      cmd.exit_code.should == 0
    end
    shell("yum --disablerepo="*" --enablerepo="updates_local" list available" do |cmd|
      cmd.exit_code.should == 0
    end
  end
end

# Vagrant stuff

describe file('/etc/sudoers.d/vagrant') do
  it { should be_file }
  it { should contain('vagrant ALL=(ALL:ALL) NOPASSWD: ALL') }
  it { should contain('Defaults !requiretty') }
end

describe user('vagrant') do
  it { should exist }
  it { should have_home_directory '/var/vagrant' }
  it { should have_authorized_key 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key' }
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
