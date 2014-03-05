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

        define_test :file_contains,   Tests::FileContains
        define_test :has_env,         Tests::HasEnv
        define_test :has_executable,  Tests::HasExecutable
        define_test :has_dir,         Tests::HasDir
        define_test :has_file,        Tests::HasFile

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
