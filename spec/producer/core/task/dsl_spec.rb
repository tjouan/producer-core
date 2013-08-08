require 'spec_helper'

module Producer::Core
  describe Task::DSL do
    let(:block)   { proc { } }
    let(:env)     { double('env') }
    subject(:dsl) { Task::DSL.new &block }

    %w[echo sh].each do |action|
      it "has `#{action}' action defined" do
        expect(dsl).to respond_to action.to_sym
      end
    end

    describe '.evaluate' do
      let(:name) { :some_task }

      it 'builds a new DSL sandbox with given code' do
        expect(Task::DSL).to receive(:new).once.with(&block).and_call_original
        Task::DSL.evaluate(name, env, &block)
      end

      it 'evaluates the DSL sandbox code with given environment' do
        dsl = double('dsl').as_null_object
        allow(Task::DSL).to receive(:new) { dsl }
        expect(dsl).to receive(:evaluate).with(env)
        Task::DSL.evaluate(name, env, &block)
      end

      it 'builds a task with its name, actions and condition' do
        dsl = double('dsl').as_null_object
        allow(Task::DSL).to receive(:new) { dsl }
        allow(dsl).to receive(:actions) { [:some_action] }
        allow(dsl).to receive(:condition) { :some_condition }
        expect(Task)
          .to receive(:new).with(:some_task, [:some_action], :some_condition)
        Task::DSL.evaluate(name, env, &block)
      end

      it 'returns the task' do
        task = double('task')
        allow(Task).to receive(:new) { task }
        expect(Task::DSL.evaluate(name, env, &block)).to be task
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

      it 'assigns true as the condition' do
        expect(dsl.instance_eval { @condition }).to be_true
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

    context 'DSL specific methods' do
      subject(:dsl) { Task::DSL.new(&block).evaluate(env) }

      describe '#condition' do
        context 'when a block is given' do
          let(:block) { proc { condition { :some_value } } }

          it 'builds a new evaluated condition' do
            expect(Condition)
              .to receive(:evaluate).with(env) do |&b|
                expect(b.call).to eq :some_value
              end
            dsl
          end

          it 'assigns the new condition' do
            condition = double('condition').as_null_object
            allow(Condition).to receive(:evaluate) { condition }
            expect(dsl.condition).to be condition
          end
        end
      end
    end

    describe '#condition' do
      context 'without block' do
        it 'returns the assigned condition' do
          dsl.instance_eval { @condition = :some_condition }
          expect(dsl.condition).to be :some_condition
        end
      end
    end
  end
end
