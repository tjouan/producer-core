require 'spec_helper'

module Producer::Core
  describe Task::DSL do
    let(:block)   { proc { } }
    let(:env)     { double('env') }
    subject(:dsl) { Task::DSL.new &block }

    %w[sh].each do |action|
      it "has `#{action}' action defined" do
        expect(dsl).to respond_to action.to_sym
      end
    end

    describe '.define_action' do
      it 'defines a new action keyword' do
        Task::DSL.define_action(:some_action, Object)
        expect(dsl).to respond_to :some_action
      end
    end

    describe '#initialize' do
      it 'assigns no action' do
        expect(dsl.actions).to be_empty
      end
    end

    describe '#actions' do
      it 'returns the assigned actions' do
        dsl.instance_eval { @actions = [:some_action] }
        expect(dsl.actions).to eq [:some_action]
      end
    end

    describe '#evaluate' do
      let(:block) { proc { throw :task_code } }

      it 'evaluates its code' do
        expect { dsl.evaluate(env) }
          .to throw_symbol :task_code
      end

      context 'when a defined keyword action is called' do
        let(:some_action_class) { Class.new(Action) }
        let(:block)             { proc { some_action } }

        before do
          Task::DSL.define_action(:some_action, some_action_class)
          dsl.evaluate(env)
        end

        it 'registers the action' do
          expect(dsl.actions.first).to be_an Action
        end

        it 'provides the env to the registered action' do
          expect(dsl.actions.first.env).to eq env
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
