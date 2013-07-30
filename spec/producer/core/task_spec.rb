require 'spec_helper'

module Producer::Core
  describe Task do
    let(:name)      { :some_task }
    let(:block)     { proc { } }
    subject(:task)  { Task.new(name, &block) }

    describe '#name' do
      it 'returns its name' do
        expect(task.name).to eq name
      end
    end

    describe '#evaluate' do
      let(:env) { double('env') }

      it 'builds a task DSL sandbox' do
        expect(Task::DSL).to receive(:new).with(&block).and_call_original
        task.evaluate(env)
      end

      it 'evaluates the task DSL sandbox' do
        dsl = double('task dsl')
        allow(Task::DSL).to receive(:new) { dsl }
        expect(dsl).to receive(:evaluate).with(env)
        task.evaluate(env)
      end
    end
  end
end
