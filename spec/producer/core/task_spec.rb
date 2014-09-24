require 'spec_helper'

module Producer::Core
  describe Task do
    class SomeAction < Action; end

    let(:env)       { Env.new }
    let(:name)      { :some_task }
    let(:condition) { :some_condition }
    subject(:task)  { described_class.new(env, name, [], condition) }

    %w[
      echo
      sh
      mkdir
      file_append
      file_replace_content
      file_write
    ].each do |action|
      it "has `#{action}' action defined" do
        expect(task).to respond_to action.to_sym
      end
    end

    describe '.define_action' do
      before { described_class.define_action(:some_action, SomeAction) }

      it 'defines a new action keyword' do
        expect(task).to respond_to :some_action
      end

      context 'when an action keyword is called' do
        it 'registers the action' do
          expect { task.some_action }.to change { task.actions.count }.by 1
        end

        it 'registers the action with current env' do
          task.some_action
          expect(task.actions.first.env).to be env
        end

        it 'registers the action with given arguments' do
          task.some_action :foo, :bar
          expect(task.actions.first.arguments).to eq %i[foo bar]
        end
      end
    end

    describe '.evaluate' do
      let(:code)      { proc { condition { :condition }; some_action } }
      let(:arguments) { [] }
      subject(:task)  { described_class.evaluate(env, name, *arguments, &code) }

      before { described_class.define_action(:some_action, SomeAction) }

      it 'returns an evaluated task' do
        expect(task).to be_a Task
      end

      it 'evaluates the task condition' do
        expect(task.condition).to be_a Condition
      end

      it 'evaluates the task actions' do
        expect(task.actions).to match [
          an_instance_of(SomeAction)
        ]
      end

      context 'when task arguments are given' do
        let(:code)      { proc { |a, b| throw a } }
        let(:arguments) { %i[foo bar] }

        it 'passes arguments as block parameters during evaluation' do
          expect { task }.to throw_symbol :foo
        end
      end
    end

    describe '#initialize' do
      subject(:task) { described_class.new(env, name) }

      it 'assigns no action' do
        expect(task.actions).to be_empty
      end

      it 'assigns a truthy condition' do
        expect(task.condition).to be_truthy
      end
    end

    describe '#to_s' do
      it 'includes the task name' do
        expect(task.to_s).to include name.to_s
      end
    end

    describe '#condition_met?' do
      context 'when condition is truthy' do
        let(:condition) { true }

        it 'returns true' do
          expect(task.condition_met?).to be true
        end
      end

      context 'when condition is falsy' do
        let(:condition) { false }

        it 'returns false' do
          expect(task.condition_met?).to be false
        end
      end
    end

    describe '#condition' do
      it 'returns current condition' do
        expect(task.condition).to eq :some_condition
      end

      context 'when a block is given' do
        it 'assigns a new evaluated condition' do
          task.condition { :some_new_condition }
          expect(task.condition.return_value).to eq :some_new_condition
        end
      end
    end

    describe '#task' do
      before { described_class.define_action(:some_action, SomeAction) }

      it 'registers a nested task as an action' do
        task.task(:nested_task) { some_action }
        expect(task.actions).to match [an_instance_of(Task)]
      end
    end

    describe '#ask' do
      let(:question)  { 'Which letter?' }
      let(:choices)   { [[:a, ?A], [:b, ?B]] }
      let(:prompter)  { instance_spy Prompter }
      subject(:ask)   { task.ask question, choices, prompter: prompter }

      it 'prompts for choices' do
        ask
        expect(prompter).to have_received(:prompt).with(question, choices)
      end

      it 'returns selected choice' do
        allow(prompter).to receive(:prompt) { :choice }
        expect(ask).to eq :choice
      end
    end

    describe '#get' do
      before { env[:some_key] = :some_value }

      it 'fetches a value from the registry at given index' do
        expect(task.get :some_key).to eq :some_value
      end
    end
  end
end
