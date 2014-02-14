module TestEnvHelpers
  require 'producer/core/testing'

  def env
    @_env ||= build_env
  end

  def output
    env.output.string
  end

  def remote_fs
    env.remote.fs
  end

  def expect_execution(command)
    opts = { expected_from: caller.first }
    RSpec::Mocks.expect_message(env.remote, :execute, opts).with(command)
  end


  private

  def build_env
    Producer::Core::Env.new(output: StringIO.new, remote: build_remote)
  end

  def build_remote
    Producer::Core::Testing::MockRemote.new('some_host.test')
  end
end
