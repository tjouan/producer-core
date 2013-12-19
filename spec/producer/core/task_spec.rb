require 'spec_helper'

module Producer::Core
  describe Task do
    let(:name)      { :some_task }
    let(:action)    { double('action') }
    let(:condition) { double('condition') }
    subject(:task)  { Task.new(name, [action], condition) }

    describe '.evaluate' do
      let(:env)   { double('env') }
      let(:block) { proc { :some_value } }

      it 'delegates to DSL.evaluate' do
        expect(Task::DSL)
          .to receive(:evaluate).with(name, env) do |&b|
            expect(b.call).to eq :some_value
          end
        Task.evaluate(name, env, &block)
      end

      it 'returns the evaluated task' do
        task = double('task')
        allow(Task::DSL).to receive(:evaluate) { task }
        expect(Task.evaluate(name, env, &block)).to be task
      end
    end

    describe '#initialize' do
      it 'assigns the name' do
        expect(task.instance_eval { @name }).to eq name
      end

      it 'assigns the actions' do
        expect(task.instance_eval { @actions }).to eq [action]
      end

      it 'assigns the condition' do
        expect(task.instance_eval { @condition }).to eq condition
      end

      context 'when only the name is given as argument' do
        subject(:task)  { Task.new(name) }

        it 'assigns no action' do
          expect(task.actions).to be_empty
        end

        it 'assigns a true condition' do
          expect(task.condition).to be true
        end
      end
    end

    describe '#name' do
      it 'returns its name' do
        expect(task.name).to eq name
      end
    end

    describe '#actions' do
      it 'returns the assigned actions' do
        expect(task.actions).to eq [action]
      end
    end

    describe '#condition' do
      it 'returns the assigned condition' do
        expect(task.condition).to be condition
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
