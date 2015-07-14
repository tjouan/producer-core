module Producer
  module Core
    module Testing
      class ArubaProgramWrapper
        def initialize argv, stdin = $stdin, stdout = $stdout, stderr = $stderr,
          kernel = Kernel
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
    end
  end
end
