module Producer
  module Core
    class Condition
      class << self
        def define_test keyword, test
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
              @tests << klass.new(@env, *args, negated: negated)
            end
          end
        end

        def evaluate env, *args, &block
          new.tap do |o|
            o.instance_eval { @env = env }
            return_value = o.instance_exec *args, &block
            o.instance_eval { @return_value = return_value }
          end
        end
      end

      extend Forwardable
      def_delegators :@env, :get, :target

      define_test :`,               Tests::ShellCommandStatus
      define_test :sh,              Tests::ShellCommandStatus
      define_test :file_contains,   Tests::FileContains
      define_test :file_eq,         Tests::FileEq
      define_test :file_match,      Tests::FileMatch
      define_test :env?,            Tests::HasEnv
      define_test :executable?,     Tests::HasExecutable
      define_test :dir?,            Tests::HasDir
      define_test :file?,           Tests::HasFile
      define_test :yaml_eq,         Tests::YAMLEq

      attr_reader :tests, :return_value

      def initialize tests = [], return_value = nil
        @tests        = tests
        @return_value = return_value
      end

      def met?
        return !!@return_value if @tests.empty?
        @tests.each { |t| return false unless t.pass? }
        true
      end

      def !
        !met?
      end
    end
  end
end
