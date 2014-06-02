require 'spec_helper'

module Producer::Core
  module Tests
    describe ConditionTest do
      let(:env)       { double 'env' }
      let(:block)     { proc { true } }
      let(:arguments) { [:some, :args] }
      subject(:test)  { described_class.new(env, block, *arguments) }

      it_behaves_like 'test'

      describe '#verify' do
        context 'when condition is met' do
          it 'returns true' do
            expect(test.verify).to be true
          end
        end

        context 'when condition is not met' do
          let(:block) { proc { false } }

          it 'returns false' do
            expect(test.verify).to be false
          end
        end
      end

      describe '#condition' do
        it 'evaluates a conditon' do
          expect(Condition).to receive(:evaluate).with(env, *arguments, &block)
          test.condition
        end

        it 'returns the evaluated condition' do
          condition = double 'condition'
          allow(Condition).to receive(:evaluate) { condition }
          expect(test.condition).to eq condition
        end
      end

      describe '#condition_args' do
        it 'returns arguments for condition' do
          expect(test.condition_args).to eq arguments
        end
      end

      describe '#condition_block' do
        it 'returns condition block' do
          expect(test.condition_block).to eq block
        end
      end
    end
  end
end
