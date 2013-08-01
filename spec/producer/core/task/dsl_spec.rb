require 'spec_helper'

module Producer::Core
  describe Task::DSL do
    let(:env)     { double('env') }
    subject(:dsl) { Task::DSL.new &block }

    describe '#evaluate' do
      let(:block) { proc { throw :task_code } }

      it 'evaluates its code' do
        expect { dsl.evaluate(env) }
          .to throw_symbol :task_code
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
          throw :after_condition
        } }

        it 'evaluates all the block' do
          expect { dsl.evaluate(env) }
            .to throw_symbol :after_condition
        end
      end

      context 'when not met (block evals to false)' do
        let(:block) { proc {
          condition { false }
          throw :after_condition
        } }

        it 'stops block evaluation' do
          expect { dsl.evaluate(env) }.not_to throw_symbol :after_condition
        end
      end
    end
  end
end
