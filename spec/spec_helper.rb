require 'producer/core'

require 'support/exit_helpers'
require 'support/fixtures_helpers'
require 'support/net_ssh_story_helpers'


RSpec.configure do |c|
  c.include NetSSHStoryHelpers, type: :ssh
  c.before(:each, type: :ssh) do
    allow(remote).to receive(:session) { connection }
  end
end
