require 'spec_helper'

module Producer::Core
  describe Condition::DSL do
    let(:block)   { proc { :some_condition_code } }
    let(:env)     { double('env') }
    subject(:dsl) { Condition::DSL.new(&block) }

    describe '.evaluate' do
      it 'builds a new DSL sandbox with given code' do
        expect(Condition::DSL).to receive(:new).with(&block).and_call_original
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

    describe '#initialize' do
      it 'assigns the code' do
        expect(dsl.instance_eval { @block }).to be block
      end
    end

    describe '#evaluate' do
      it 'returns the value returned by the assigned block' do
        expect(dsl.evaluate).to eq block.call
      end
    end
  end
end
