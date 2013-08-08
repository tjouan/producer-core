require 'spec_helper'

module Producer::Core
  describe Condition do
    let(:expression)  { double('expression') }
    let(:condition)   { Condition.new(expression) }

    describe '.evaluate' do
      let(:env)   { double('env') }
      let(:block) { proc { :some_condition_code } }

      it 'delegates to DSL.evaluate' do
        expect(Condition::DSL)
          .to receive(:evaluate).with(env) do |&b|
            expect(b.call).to eq :some_condition_code
          end
        Condition.evaluate(env, &block)
      end

      it 'returns the evaluated condition' do
        condition = double('condition')
        allow(Condition::DSL).to receive(:evaluate) { condition }
        expect(Condition.evaluate(env, &block)).to be condition
      end
    end

    describe '#initialize' do
      it 'assigns the expression' do
        expect(condition.instance_eval { @expression }).to be expression
      end
    end

    describe '#!' do
      it 'returns the negated expression' do
        expect(condition.!).to be !expression
      end
    end
  end
end
