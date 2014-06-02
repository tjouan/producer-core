module Producer
  module Core
    class Condition
      class DSL
        class << self
          def define_test(keyword, test)
            {
              keyword         => false,
              "no_#{keyword}" => true
            }.each do |kw, negated|
              define_method(kw) do |*args|
                if test.respond_to? :call
                  args  = [test, *args]
                  klass = Tests::ConditionTest
                else
                  klass = test
                end
                t = klass.new(@env, *args, negated: negated)
                @tests << t
              end
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

        def evaluate(*args)
          instance_exec *args, &@block
        end
      end
    end
  end
end
