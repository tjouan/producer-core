require 'aruba/cucumber'
require 'aruba/in_process'

require 'producer/core'
require 'producer/core/testing/aruba_program_wrapper'
require 'producer/core/testing/cucumber/etc_steps'
require 'producer/core/testing/cucumber/execution_steps'
require 'producer/core/testing/cucumber/output_steps'
require 'producer/core/testing/cucumber/recipe_steps'
require 'producer/core/testing/cucumber/remote_steps'
require 'producer/core/testing/cucumber/ssh_steps'

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

# Enable cucumber-sshd "fast" mode (persists sshd across scenarios), and
# register hooks for @sshd tagged scenarios.
Before do
  @_sshd_fast = true
end
require 'cucumber/sshd/cucumber'
