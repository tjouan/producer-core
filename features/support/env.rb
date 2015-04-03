require 'aruba/cucumber'
require 'aruba/in_process'
require 'producer/core'

class ArubaProgramWrapper
  def initialize(argv, stdin = $stdin, stdout = $stdout, stderr = $stderr,
    kernel = Kernel)
    @argv   = argv
    @stdin  = stdin
    @stdout = stdout
    @stderr = stderr
    @kernel = kernel
  end

  def execute!
    Producer::Core::CLI.run!(
      @argv.dup, stdin: @stdin, stdout: @stdout, stderr: @stderr
    )
  rescue SystemExit => e
    @kernel.exit e.status
  end
end


# Raise aruba default timeout so test suite can run on a slow machine.
Before do
  @aruba_timeout_seconds = 8
end

# Use aruba "in process" optimization only for scenarios not tagged @exec.
# We need a real process in a few cases: real program name, interactive usage…
Before('@exec') do
  Aruba.process = Aruba::SpawnProcess
end

Before('~@exec') do
  Aruba::InProcess.main_class = ArubaProgramWrapper
  Aruba.process = Aruba::InProcess
end

# Fake home directory for @fake_home tagged scenarios.
Before('@fake_home') do
  ENV['HOME'] = File.expand_path(current_dir)
end

# Enable cucumber-sshd "fast" mode (persists sshd across scenarios), and
# register hooks for @sshd tagged scenarios.
Before do
  @_sshd_fast = true
end
require 'cucumber/sshd/cucumber'
