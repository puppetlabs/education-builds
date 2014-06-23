#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

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
  it { should contain('puppet-mode.el') }
end

file ('/root/.emacs.d/puppet-mode.el') do
  it { should contain('puppet-mode-syntax-table') }
end

describe package('vim-enhanced') do
  it { should be_installed }
end

describe file('/root/.vim') do
  it { should be_directory }
end

describe file('/root/.vim/syntax/puppet.vim') do
  it { should contain('puppet syntax file') }
end

describe file('/root/.vimrc') do
  it { should contain('syntax on') }
end

