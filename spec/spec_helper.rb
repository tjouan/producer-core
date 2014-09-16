require 'producer/core'

Dir['spec/support/**/*.rb'].map { |e| require e.gsub 'spec/', '' }


RSpec.configure do |c|
  c.include TestEnvHelpers, :env

  c.include NetSSHStoryHelpers, :ssh
  c.before(:each, :ssh) do
    allow(Net::SSH).to receive(:start) { connection }
  end
end
