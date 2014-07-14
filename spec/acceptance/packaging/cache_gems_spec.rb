#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe file('/root/.gemrc') do
  it {should be_file }
end

cached_gems = [
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
  'puppetlabs_spec_helper',
]

describe 'Gems' do
  it 'should be cached' do
    cached_gems.each do |gem|
      expect(shell("file /var/cache/rubygems/gems/#{gem}*.gem").stdout).to match /POSIX tar archive/
    end
  end
end
