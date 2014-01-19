require 'spec_helper'

module Producer::Core
  describe Condition do
    let(:test_ok)       { double 'test', pass?: true }
    let(:test_ko)       { double 'test', pass?: false }
    let(:tests)         { [test_ok, test_ko] }
    subject(:condition) { Condition.new(tests) }

    describe '.evaluate' do
      let(:env)             { double 'env' }
      let(:block)           { proc { some_test; :some_return_value } }
      let(:some_test_class) { Class.new(Test) }
      subject(:condition)   { described_class.evaluate(env, &block) }

      before { Condition::DSL.define_test(:some_test, some_test_class) }

      it 'returns an evaluated condition' do
        expect(condition.tests.first).to be_a Test
        expect(condition.return_value).to eq :some_return_value
      end
    end

    describe '#initialize' do
      it 'assigns the tests' do
        expect(condition.tests).to eq tests
      end

      it 'assigns nil as a default return value' do
        expect(condition.return_value).to be nil
      end

      context 'when a return value is given as argument' do
        let(:return_value)  { :some_return_value }
        subject(:condition) { described_class.new(tests, return_value) }

        it 'assigns the return value' do
          expect(condition.return_value).to eq return_value
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
  end
end
