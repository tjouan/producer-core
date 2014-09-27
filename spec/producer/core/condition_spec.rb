require 'spec_helper'

module Producer::Core
  describe Condition do
    subject(:condition) { described_class.new }

    %w[
      `
      sh
      file_contains
      file_eq
      file_match
      dir?
      env?
      executable?
      file?
    ].each do |test|
      it "has `#{test}' test defined" do
        expect(condition).to respond_to test.to_sym
      end
    end

    describe '.define_test' do
      let(:some_test) { Test }

      before { described_class.define_test(:some_test, some_test) }

      it 'defines a new test keyword' do
        expect(condition).to respond_to :some_test
      end

      it 'defines the negated test' do
        expect(condition).to respond_to :no_some_test
      end

      context 'when a test keyword is called' do
        it 'registers the test' do
          expect { condition.some_test }.to change { condition.tests.count }.by 1
        end

        it 'registers the test with assigned env' do
          env = double 'env'
          condition.instance_eval { @env = env }
          condition.some_test
          expect(condition.tests.last.env).to be env
        end

        it 'registers the test with given arguments' do
          condition.some_test :foo, :bar
          expect(condition.tests.last.arguments).to eq %i[foo bar]
        end

        context 'when given test is callable' do
          let(:some_test) { proc { } }

          before { condition.some_test }

          it 'registers a condition test' do
            expect(condition.tests.last).to be_a Tests::ConditionTest
          end

          it 'registers the test with given block' do
            expect(condition.tests.last.condition_block).to be some_test
          end

          it 'registers the test with given arguments' do
            condition.some_test :foo, :bar
            expect(condition.tests.last.condition_args).to eq %i[foo bar]
          end
        end
      end

      context 'when a negated test keyword is called' do
        it 'registers a negated test' do
          condition.no_some_test
          expect(condition.tests.last).to be_negated
        end
      end
    end

    describe '.evaluate' do
      let(:env)           { double 'env' }
      let(:code)          { proc { some_test; :some_return_value } }
      let(:some_test)     { Class.new(Test) }
      let(:arguments)     { [] }
      subject(:condition) { described_class.evaluate(env, *arguments, &code) }

      before { described_class.define_test(:some_test, some_test) }

      it 'returns an evaluated condition' do
        expect(condition).to be_a Condition
      end

      it 'evaluates the condition tests' do
        expect(condition.tests.first).to be_a Test
      end

      it 'evaluates the condition return value' do
        expect(condition.return_value).to eq :some_return_value
      end

      context 'when arguments are given' do
        let(:code)      { proc { |a, b| throw a } }
        let(:arguments) { %i[foo bar] }

        it 'passes arguments as block parameters' do
          expect { condition }
            .to throw_symbol :foo
        end
      end
    end

    describe '#initialize' do
      it 'assigns no tests' do
        expect(condition.tests).to be_empty
      end

      it 'assigns the return value as nil' do
        expect(condition.return_value).to be nil
      end
    end

    describe '#met?' do
      let(:test_ok)       { instance_spy Test, pass?: true }
      let(:test_ko)       { instance_spy Test, pass?: false }
      subject(:condition) { described_class.new(tests) }

      context 'when all tests are successful' do
        let(:tests) { [test_ok, test_ok] }

        it 'returns true' do
          expect(condition.met?).to be true
        end
      end

      context 'when one test is unsuccessful' do
        let(:tests) { [test_ok, test_ko] }

        it 'returns false' do
          expect(condition.met?).to be false
        end
      end

      context 'when there are no test' do
        let(:tests)         { [] }
        subject(:condition) { described_class.new([], return_value) }

        context 'and return value is truthy' do
          let(:return_value) { :some_truthy_value }

          it 'returns true' do
            expect(condition.met?).to be true
          end
        end

        context 'and return value is falsy' do
          let(:return_value) { nil }

          it 'returns false' do
            expect(condition.met?).to be false
          end
        end
      end
    end

    describe '#!' do
      [true, false].each do |b|
        context "when #met? return #{b}" do
          before { allow(condition).to receive(:met?) { b } }

          it 'returns the negated #met?' do
            expect(condition.!).to be !condition.met?
          end
        end
      end
    end

    describe '#get' do
      let(:env) { Env.new }

      it 'delegates to env registry' do
        expect(env).to receive(:get).with :some_key
        described_class.evaluate(env, []) { get :some_key }
      end
    end

    describe '#target' do
      let(:env) { Env.new }

      before { env.target = :some_target }

      it 'returns current env target' do
        condition = described_class.evaluate(env, []) { target == :some_target }
        expect(condition).to be_met
      end
    end
  end
end
