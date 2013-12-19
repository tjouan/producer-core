require 'producer/core'

require 'support/exit_helpers'
require 'support/fixtures_helpers'
require 'support/net_ssh_story_helpers'
require 'support/tests_helpers'


RSpec.configure do |c|
  c.include NetSSHStoryHelpers, :ssh
  c.before(:each, :ssh) do
    allow(Net::SSH).to receive(:start) { connection }
  end
end
