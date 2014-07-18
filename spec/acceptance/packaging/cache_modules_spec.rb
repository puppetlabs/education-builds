#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

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
  'puppetlabs-pe_gem',
  'stahnma-epel',
  'nanliu-staging',
  'puppetlabs/git',
  'zack/r10k',
  'zack/exports'
  ]

# Just check that they are present.
# Functional tests elsewhere will determine whether
# the cached versions work as desired.
# This way we can eventually always cache the latest versions of all modules
# and run (functional) tests against them
describe 'Forge Modules' do
  it 'should be cached' do
    cached_modules.each do |mod|
      expect(shell("file /usr/src/forge/#{mod}*.tar.gz").stdout).to match /gzip compressed data/
    end
  end
end

