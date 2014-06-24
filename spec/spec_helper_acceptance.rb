require 'beaker-rspec/spec_helper'

# we don't need to install PE
#   - for the learning VM, PE is already installed
#   - for the training VM, a test should ensure that PE can be installed, offline, using the cached installer

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install modules or set up stuff for tests.
    # Leaving this empty for now, since this isn't your typical module test
  end
end

