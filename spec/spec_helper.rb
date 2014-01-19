require 'producer/core'

require 'support/exit_helpers'
require 'support/fixtures_helpers'
require 'support/net_ssh_story_helpers'


RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true

  c.include NetSSHStoryHelpers, :ssh
  c.before(:each, :ssh) do
    allow(Net::SSH).to receive(:start) { connection }
  end
end
