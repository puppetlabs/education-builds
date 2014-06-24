#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

if hosts_as('training').length > 0
  describe file('/root/.ssh_keygen.sh') do
    it { should be_mode 755 }
  end
  describe 'WordPress installer' do
    it 'should be cached' do
      expect(shell("file /usr/src/wordpress/wordpress*.tar.gz").stdout).to match /gzip compressed data/
    end
  end
end
