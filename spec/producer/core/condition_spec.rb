require 'spec_helper'

module Producer::Core
  describe Condition do
    include TestsHelpers

    let(:tests)         { [test_ok, test_ko] }
    subject(:condition) { Condition.new(tests) }

    describe '.evaluate' do
      let(:env)   { double('env') }
      let(:block) { proc { :some_condition_code } }

      it 'delegates to DSL.evaluate' do
        expect(Condition::DSL)
          .to receive(:evaluate).with(env) do |&b|
            expect(b).to be block
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
      it 'assigns the tests' do
        expect(condition.instance_eval { @tests }).to eq tests
      end

      it 'assigns nil as a default return value' do
        expect(condition.instance_eval { @return_value }).to be nil
      end

      context 'when a return value is given as argument' do
        let(:return_value)  { :some_return_value }
        subject(:condition) { Condition.new(tests, return_value) }

        it 'assigns the return value' do
          expect(condition.instance_eval { @return_value }).to eq return_value
        end
      end
    end

    describe '#met?' do
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
        subject(:condition) { Condition.new([], return_value) }

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
      %w[true false].each do |b|
        context "when #met? return #{b}" do
          it 'returns the negated #met?' do
            expect(condition.!).to be !condition.met?
          end
        end
      end
    end
  end
end
