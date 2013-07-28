require 'spec_helper'

module Producer::Core
  describe Task do
    let(:name)      { :some_task }
    let(:block)     { Proc.new { } }
    subject(:task)  { Task.new(name, &block) }

    describe '#name' do
      it 'returns its name' do
        expect(task.name).to eq name
      end
    end

    describe '#evaluate' do
      it 'builds a task DSL sandbox' do
        expect(Task::DSL).to receive(:new).with(&block)
        task.evaluate
      end
    end

    describe Task::DSL do
      let(:dsl) { Task::DSL.new &block }

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

          it 'evaluates all the block' do
            expect { dsl }.not_to raise_error
          end
        end
      end
    end
  end
end
