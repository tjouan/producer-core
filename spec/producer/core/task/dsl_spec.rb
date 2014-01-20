require 'spec_helper'

module Producer::Core
  describe Task::DSL do
    let(:block)   { proc {} }
    let(:env)     { double 'env' }
    subject(:dsl) { Task::DSL.new(env, &block) }

    %w[echo sh file_write].each do |action|
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
      it 'assigns the given env' do
        expect(dsl.env).to be env
      end

      it 'assigns no action' do
        expect(dsl.actions).to be_empty
      end

      it 'assigns true as the condition' do
        expect(dsl.instance_eval { @condition }).to be true
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

      context 'when a defined keyword action is called' do
        let(:some_action_class) { Class.new(Action) }
        let(:block)             { proc { some_action } }

        before do
          Task::DSL.define_action(:some_action, some_action_class)
          dsl.evaluate
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
      subject(:dsl) { Task::DSL.new(env, &block).evaluate }

      describe '#condition' do
        context 'when a block is given' do
          let(:block) { proc { condition { :some_value } } }

          it 'builds a new evaluated condition' do
            expect(Condition)
              .to receive :evaluate do |&b|
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
  end
end
