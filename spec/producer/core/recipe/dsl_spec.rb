require 'spec_helper'

module Producer::Core
  class Recipe
    describe DSL do
      include FixturesHelpers

      let(:code)    { proc { :some_recipe_code } }
      let(:env)     { Env.new }
      subject(:dsl) { DSL.new(env, &code) }

      describe '#initialize' do
        it 'assigns the given env' do
          expect(dsl.env).to be env
        end

        it 'assigns no task' do
          expect(dsl.tasks).to be_empty
        end

        context 'when a string of code is given as argument' do
          let(:code)    { 'some_code' }
          subject(:dsl) { described_class.new(env, code) }

          it 'assigns the string of code' do
            expect(dsl.code).to eq code
          end
        end

        context 'when a code block is given as argument' do
          it 'assigns the code block' do
            expect(dsl.block).to be code
          end
        end
      end

      describe '#tasks' do
        let(:code) { proc { task(:some_task) {} } }

        it 'returns registered tasks' do
          dsl.evaluate
          expect(dsl.tasks[0].name).to eq :some_task
        end
      end

      describe '#evaluate' do
        it 'evaluates its code' do
          dsl = described_class.new(env) { throw :recipe_code }
          expect { dsl.evaluate }.to throw_symbol :recipe_code
        end

        it 'returns itself' do
          expect(dsl.evaluate).to eq dsl
        end
      end

      describe '#source' do
        let(:filepath)  { fixture_path_for 'recipes/throw' }

        it 'sources the recipe given as argument' do
          expect { dsl.source filepath }.to throw_symbol :recipe_code
        end
      end

      describe '#target' do
        let(:host) { 'some_host.example' }

        it 'registers the target host in the env' do
          dsl.target host
          expect(env.target).to eq host
        end
      end

      describe '#task' do
        it 'registers a new evaluated task' do
          expect { dsl.task(:some_task) { :some_task_code } }
            .to change { dsl.tasks.count }.by 1
        end
      end

      describe '#macro' do
        it 'defines the new recipe keyword' do
          dsl.macro :hello
          expect(dsl).to respond_to(:hello)
        end

        context 'when a defined macro is called' do
          before { dsl.macro(:hello) { :some_macro_code } }

          it 'registers the new task' do
            expect { dsl.hello }.to change { dsl.tasks.count }.by 1
          end
        end

        context 'when a defined macro is called with arguments' do
          before { dsl.macro(:hello) { |a, b| echo a, b } }

          it 'evaluates task code with arguments' do
            dsl.hello :some, :args
            expect(dsl.tasks.first.actions.first.arguments).to eq [:some, :args]
          end
        end
      end

      describe '#test_macro' do
        it 'defines the new test' do
          condition_dsl = double 'condition dsl'
          test_block = proc {}
          expect(condition_dsl)
            .to receive(:define_test).with(:some_test, test_block)
          dsl.test_macro(:some_test, dsl: condition_dsl, &test_block)
        end
      end

      describe '#set' do
        it 'registers a key/value pair in env registry' do
          dsl.set :some_key, :some_value
          expect(env[:some_key]).to eq :some_value
        end
      end

      describe '#get' do
        it 'fetches a value from the registry at given index' do
          dsl.set :some_key, :some_value
          expect(dsl.get :some_key).to eq :some_value
        end
      end
    end
  end
end
