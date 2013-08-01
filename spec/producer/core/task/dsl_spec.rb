require 'spec_helper'

module Producer::Core
  describe Task::DSL do
    let(:env)     { double('env') }
    subject(:dsl) { Task::DSL.new &block }

    describe '#evaluate' do
      let(:block) { proc { raise 'error from task' } }

      it 'evaluates its code' do
        expect { dsl.evaluate(env) }
          .to raise_error(RuntimeError, 'error from task')
      end

      context 'when given block is invalid' do
        it 'raises a TaskEvaluationError on NameError' do
          dsl = Task::DSL.new { invalid_action }
          expect { dsl.evaluate(env) }
            .to raise_error(TaskEvaluationError)
        end
      end
    end

    describe '#condition' do
      context 'when met (block evals to true)' do
        let(:block) { proc {
          condition { true }
          raise 'error after condition'
        } }

        it 'evaluates all the block' do
          expect { dsl.evaluate(env) }
            .to raise_error(RuntimeError, 'error after condition')
        end
      end

      context 'when not met (block evals to false)' do
        let(:block) { proc {
          condition { false }
          raise
        } }

        it 'stops block evaluation' do
          expect { dsl.evaluate(env) }.not_to raise_error
        end
      end
    end
  end
end
