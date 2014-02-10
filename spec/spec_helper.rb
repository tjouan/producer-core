require 'producer/core'

Dir['spec/support/**/*.rb'].map { |e| require e.gsub 'spec/', '' }


RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true

  c.include NetSSHStoryHelpers, :ssh
  c.before(:each, :ssh) do
    allow(Net::SSH).to receive(:start) { connection }
  end
end
