require 'spec_helper'

module Producer::Core
  describe Condition::DSL do
    let(:block)   { proc { :some_condition_code } }
    let(:env)     { double('env') }
    subject(:dsl) { Condition::DSL.new(env, &block) }

    describe '.evaluate' do
      it 'builds a new DSL sandbox with given env and code' do
        expect(Condition::DSL)
          .to receive(:new).with(env, &block).and_call_original
        Condition::DSL.evaluate(env, &block)
      end

      it 'evaluates the DSL sandbox code' do
        dsl = double('dsl')
        allow(Condition::DSL).to receive(:new) { dsl }
        expect(dsl).to receive(:evaluate)
        Condition::DSL.evaluate(env, &block)
      end

      it 'builds a condition with value returned from DSL evaluation' do
        expect(Condition)
          .to receive(:new).with(dsl.evaluate)
        Condition::DSL.evaluate(env, &block)
      end

      it 'returns the condition' do
        condition = double('task')
        allow(Condition).to receive(:new) { condition }
        expect(Condition::DSL.evaluate(env, &block)).to be condition
      end
    end

    describe '.define_test' do
      let(:some_test_class) { double('SomeTest class') }

      before do
        Condition::DSL.define_test(:some_test, some_test_class)
      end

      it 'defines a new test keyword' do
        expect(dsl).to respond_to :some_test
      end

      context 'defined test keyword' do
        let(:arguments) { [:some, :arguments] }

        it 'builds a new test with the env and given arguments' do
          expect(some_test_class).to receive(:new).with(env, arguments)
          dsl.some_test(arguments)
        end

        it 'registers the new test' do
          some_test = double('SomeTest instance')
          allow(some_test_class).to receive(:new) { some_test }
          dsl.some_test(arguments)
          expect(dsl.tests).to include(some_test)
        end
      end
    end

    describe '#initialize' do
      it 'assigns the code' do
        expect(dsl.instance_eval { @block }).to be block
      end

      it 'assigns the env' do
        expect(dsl.instance_eval { @env }).to be env
      end

      it 'assigns no test' do
        expect(dsl.tests).to be_empty
      end
    end

    describe '#tests' do
      it 'returns the assigned tests' do
        dsl.instance_eval { @tests = [:some_test] }
        expect(dsl.tests).to eq [:some_test]
      end
    end

    describe '#evaluate' do
      it 'returns the value returned by the assigned block' do
        expect(dsl.evaluate).to eq block.call
      end
    end
  end
end
