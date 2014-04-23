module Producer
  module Core
    class Condition
      class DSL
        class << self
          def define_test(keyword, klass)
            define_method(keyword) do |*args|
              @tests << klass.new(@env, *args)
            end
            define_method("no_#{keyword}") do |*args|
              @tests << klass.new(@env, *args, negated: true)
            end
          end
        end

        define_test :`,               Tests::ShellCommandStatus
        define_test :sh,              Tests::ShellCommandStatus
        define_test :file_contains,   Tests::FileContains
        define_test :env?,            Tests::HasEnv
        define_test :executable?,     Tests::HasExecutable
        define_test :dir?,            Tests::HasDir
        define_test :file?,           Tests::HasFile

        attr_reader :block, :env, :tests

        def initialize(env, &block)
          @env    = env
          @block  = block
          @tests  = []
        end

        def evaluate
          instance_eval &@block
        end
      end
    end
  end
end
