require 'producer/core'

Dir['spec/support/**/*.rb'].map { |e| require e.gsub 'spec/', '' }


RSpec.configure do |c|
  c.disable_monkey_patching!

  c.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  c.include TestEnvHelpers, :env

  c.include NetSSHStoryHelpers, :ssh
  c.before :example, :ssh do
    allow(Net::SSH).to receive(:start) { connection }
  end
end
