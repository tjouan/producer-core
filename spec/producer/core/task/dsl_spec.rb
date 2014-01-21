require 'spec_helper'

module Producer::Core
  describe Task::DSL do
    let(:block)   { proc {} }
    let(:env)     { Env.new }
    subject(:dsl) { Task::DSL.new(env, &block) }

    %w[echo sh file_write].each do |action|
      it "has `#{action}' action defined" do
        expect(dsl).to respond_to action.to_sym
      end
    end

    describe '.define_action' do
      let(:some_action_class) { Class.new(Action) }

      before { described_class.define_action(:some_action, some_action_class) }

      it 'defines a new action keyword' do
        expect(dsl).to respond_to :some_action
      end

      context 'when an action keyword is called' do
        it 'registers the action' do
          expect { dsl.some_action }.to change { dsl.actions.count }.by 1
        end

        it 'registers the action with current env' do
          dsl.some_action
          expect(dsl.actions.first.env).to be env
        end

        it 'registers the action with given arguments' do
          dsl.some_action :some, :args
          expect(dsl.actions.first.arguments).to eq [:some, :args]
        end
      end
    end

    describe '#initialize' do
      it 'assigns the given env' do
        expect(dsl.env).to be env
      end

      it 'assigns the given block' do
        expect(dsl.block).to be block
      end

      it 'assigns no action' do
        expect(dsl.actions).to be_empty
      end

      it 'assigns true as the condition' do
        expect(dsl.condition).to be true
      end
    end

    describe '#evaluate' do
      let(:block) { proc { throw :task_code } }

      it 'evaluates its code' do
        expect { dsl.evaluate }
          .to throw_symbol :task_code
      end

      context 'when arguments are given' do
        let(:block) { proc { |e| throw e } }

        it 'passes arguments as block parameters' do
          expect { dsl.evaluate :some_argument }
            .to throw_symbol :some_argument
        end
      end
    end

    describe '#condition' do
      context 'when a block is given' do
        it 'assigns a new evaluated condition' do
          dsl.condition { :some_return_value }
          expect(dsl.condition.return_value).to eq :some_return_value
        end
      end
    end

    describe '#ask' do
      let(:question)        { 'Which letter?' }
      let(:choices)         { [[:a, ?A], [:b, ?B]] }
      let(:prompter_class)  { double('prompter class').as_null_object }
      subject(:ask)         { dsl.ask question, choices,
                              prompter: prompter_class }

      it 'builds a prompter' do
        expect(prompter_class).to receive(:new).with(env.input, env.output)
        ask
      end

      it 'prompts and returns the choice' do
        prompter = double 'prompter'
        allow(prompter_class).to receive(:new) { prompter }
        allow(prompter).to receive(:prompt) { :choice }
        expect(ask).to eq :choice
      end
    end
  end
end
