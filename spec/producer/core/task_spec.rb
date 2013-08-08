require 'spec_helper'

module Producer::Core
  describe Task do
    let(:name)      { :some_task }
    let(:block)     { proc { } }
    subject(:task)  { Task.new(name, &block) }

    describe '#initialize' do
      it 'assigns the name' do
        expect(task.instance_eval { @name }).to eq name
      end

      it 'assigns the block' do
        expect(task.instance_eval { @block }).to be block
      end

      it 'has no action' do
        expect(task.actions).to be_empty
      end
    end

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
        dsl = double('task DSL').as_null_object
        allow(Task::DSL).to receive(:new) { dsl }
        expect(dsl).to receive(:evaluate).with(env)
        task.evaluate(env)
      end

      it 'assigns the evaluated actions' do
        dsl = double('dsl').as_null_object
        allow(Task::DSL).to receive(:new) { dsl }
        allow(dsl).to receive(:actions) { [:some_action] }
        task.evaluate(env)
        expect(task.actions).to eq [:some_action]
      end
    end
  end
end
