require 'aruba/cucumber'
require 'aruba/in_process'

ENV['CUCUMBER_SSHD_PERSIST'] = 'yes'
require 'cucumber/sshd/cucumber'

require 'producer/core'
require 'producer/core/testing/aruba_program_wrapper'
require 'producer/core/testing/cucumber/etc_steps'
require 'producer/core/testing/cucumber/execution_steps'
require 'producer/core/testing/cucumber/output_steps'
require 'producer/core/testing/cucumber/recipe_steps'
require 'producer/core/testing/cucumber/remote_steps'
require 'producer/core/testing/cucumber/ssh_steps'

# Change aruba working directory to match cucumber-sshd one.
Aruba.configure do |config|
  config.working_directory = 'tmp/home'
end

# Raise aruba default timeout so test suite can run on a slow machine.
Before do
  @aruba_timeout_seconds = 8
end

# Use aruba "in process" optimization only for scenarios not tagged @exec.
# We need a real process in a few cases: real program name, interactive usage…
Before('@exec') do
  aruba.config.command_launcher = :spawn
end

Before('~@exec') do
  aruba.config.command_launcher = :in_process
  aruba.config.main_class       = Producer::Core::Testing::ArubaProgramWrapper
end
