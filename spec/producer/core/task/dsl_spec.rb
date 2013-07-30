require 'spec_helper'

module Producer::Core
  describe Task::DSL do
    subject(:dsl) { Task::DSL.new &block }

    describe '#initialize' do
      let(:block) { Proc.new { raise 'error from task' } }

      it 'evaluates its block' do
        expect { dsl }.to raise_error(RuntimeError, 'error from task')
      end
    end

    describe '#condition' do
      context 'condition is met (block evals to true)' do
        let(:block) { Proc.new {
          condition { true }
          raise 'error after condition'
        } }

        it 'evaluates all the block' do
          expect { dsl }.to raise_error(RuntimeError, 'error after condition')
        end
      end

      context 'condition is not met (block evals to false)' do
        let(:block) { Proc.new {
          condition { false }
          raise
        } }

        it 'stops block evaluation' do
          expect { dsl }.not_to raise_error
        end
      end
    end
  end
end
