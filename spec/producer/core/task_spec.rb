require 'spec_helper'

module Producer::Core
  describe Task do
    let(:name)      { :some_task }
    let(:action)    { double 'action' }
    let(:condition) { double 'condition' }
    subject(:task)  { Task.new(name, [action], condition) }

    describe '.evaluate' do
      let(:name)              { :some_task }
      let(:env)               { double 'env' }
      let(:block)             { proc { condition { :condition }; some_action } }
      let(:some_action_class) { Class.new(Action) }
      subject(:task)          { Task.evaluate(name, env, :some, :args, &block) }

      before { Task::DSL.define_action(:some_action, some_action_class) }

      it 'returns an evaluated task' do
        expect(task).to be_kind_of Task
      end

      context 'evaluated task' do
        it 'has the requested name' do
          expect(task.name).to eq name
        end

        it 'has the requested actions' do
          expect(task.actions.first).to be_kind_of some_action_class
        end

        it 'has the requested condition' do
          expect(task.condition.return_value).to be :condition
        end
      end
    end

    describe '#initialize' do
      it 'assigns the name' do
        expect(task.name).to eq name
      end

      it 'assigns the actions' do
        expect(task.actions).to eq [action]
      end

      it 'assigns the condition' do
        expect(task.condition).to eq condition
      end

      context 'when only the name is given as argument' do
        subject(:task) { Task.new(name) }

        it 'assigns no action' do
          expect(task.actions).to be_empty
        end

        it 'assigns a true condition' do
          expect(task.condition).to be true
        end
      end
    end

    describe '#condition_met?' do
      context 'when condition is truthy' do
        let(:condition) { Condition.new([], true) }

        it 'returns true' do
          expect(task.condition_met?).to be true
        end
      end

      context 'when condition is falsy' do
        let(:condition) { Condition.new([], false) }

        it 'returns false' do
          expect(task.condition_met?).to be false
        end
      end
    end
  end
end
