require 'producer/core'

require 'support/exit_helpers'
require 'support/fixtures_helpers'
require 'support/net_ssh_story_helpers'
require 'support/tests_helpers'


RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true

  c.include NetSSHStoryHelpers, :ssh
  c.before(:each, :ssh) do
    allow(remote).to receive(:session) { connection }
  end
end
