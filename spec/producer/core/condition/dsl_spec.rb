require 'spec_helper'

module Producer::Core
  describe Condition::DSL do
    let(:block)   { proc { :some_condition_code } }
    let(:env)     { double 'env' }
    subject(:dsl) { Condition::DSL.new(env, &block) }

    %w[has_dir has_env has_file].each do |test|
      it "has `#{test}' test defined" do
        expect(dsl).to respond_to test.to_sym
      end
    end

    describe '.define_test' do
      let(:some_test_class) { Test }

      before { Condition::DSL.define_test(:some_test, some_test_class) }

      it 'defines a new test keyword' do
        expect(dsl).to respond_to :some_test
      end

      it 'defines the negated test' do
        expect(dsl).to respond_to :no_some_test
      end

      context 'when a test keyword is called' do
        it 'registers the test' do
          expect { dsl.some_test }.to change { dsl.tests.count }.by 1
        end

        it 'registers the test with current env' do
          dsl.some_test
          expect(dsl.tests.first.env).to be env
        end

        it 'registers the test with given arguments' do
          dsl.some_test :some, :args
          expect(dsl.tests.first.arguments).to eq [:some, :args]
        end
      end

      context 'when a negated test keyword is called' do
        it 'registers a negated test' do
          dsl.no_some_test
          expect(dsl.tests.first).to be_negated
        end
      end
    end

    describe '#initialize' do
      it 'assigns the env' do
        expect(dsl.env).to be env
      end

      it 'assigns the code' do
        expect(dsl.block).to be block
      end

      it 'assigns no test' do
        expect(dsl.tests).to be_empty
      end
    end

    describe '#evaluate' do
      it 'evaluates its code' do
        dsl = described_class.new(env) { throw :condition_code }
        expect { dsl.evaluate }.to throw_symbol :condition_code
      end

      it 'returns the value returned by the assigned block' do
        expect(dsl.evaluate).to eq block.call
      end
    end
  end
end
