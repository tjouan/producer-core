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
    @kernel.exit(e.status)
  end
end


Before do
  @_sshd_fast = true
end
require 'cucumber/sshd/cucumber'

Before('@exec') do
  Aruba.process = Aruba::SpawnProcess
end

Before('~@exec') do
  Aruba::InProcess.main_class = ArubaProgramWrapper
  Aruba.process = Aruba::InProcess
end
