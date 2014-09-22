require 'spec_helper'

module Producer::Core
  class Condition
    describe DSL do
      let(:block)   { proc { :some_condition_code } }
      let(:env)     { double 'env' }
      subject(:dsl) { DSL.new(env, &block) }

      %w[
        `
        sh
        file_contains
        file_eq
        dir?
        env?
        executable?
        file?
      ].each do |test|
        it "has `#{test}' test defined" do
          expect(dsl).to respond_to test.to_sym
        end
      end

      describe '.define_test' do
        let(:some_test) { Test }

        before { described_class.define_test(:some_test, some_test) }

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
            expect(dsl.tests.last.env).to be env
          end

          it 'registers the test with given arguments' do
            dsl.some_test :some, :args
            expect(dsl.tests.last.arguments).to eq [:some, :args]
          end

          context 'when given test is callable' do
            let(:some_test) { proc {} }

            before { dsl.some_test }

            it 'registers a condition test' do
              expect(dsl.tests.last).to be_a Tests::ConditionTest
            end

            it 'registers the test with given block' do
              expect(dsl.tests.last.condition_block).to be some_test
            end

            it 'registers the test with given arguments' do
              dsl.some_test :some, :args
              expect(dsl.tests.last.condition_args).to eq [:some, :args]
            end
          end
        end

        context 'when a negated test keyword is called' do
          it 'registers a negated test' do
            dsl.no_some_test
            expect(dsl.tests.last).to be_negated
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

        context 'when arguments are given' do
          let(:block) { proc { |e| throw e } }

          it 'passes arguments as block parameters' do
            expect { dsl.evaluate :some_argument }
              .to throw_symbol :some_argument
          end
        end
      end
    end
  end
end
