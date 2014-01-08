require 'spec_helper'

module Producer::Core
  describe Recipe::DSL do
    include FixturesHelpers

    let(:code)    { proc { :some_recipe_code } }
    let(:env)     { double('env').as_null_object }
    subject(:dsl) { Recipe::DSL.new(env, &code) }

    describe '#initialize' do
      it 'assigns the given env' do
        expect(dsl.env).to be env
      end

      it 'assigns no task' do
        expect(dsl.tasks).to be_empty
      end

      context 'when a string of code is given as argument' do
        let(:code)    { 'some_code' }
        subject(:dsl) { Recipe::DSL.new(env, code) }

        it 'assigns the string of code' do
          expect(dsl.instance_eval { @code }).to eq code
        end
      end

      context 'when a code block is given as argument' do
        it 'assigns the code block' do
          expect(dsl.instance_eval { @block }).to be code
        end
      end
    end

    describe '#tasks' do
      let(:code) { proc { task(:some_task) { } } }

      it 'returns registered tasks' do
        dsl.evaluate
        expect(dsl.tasks[0].name).to eq :some_task
      end
    end

    describe '#evaluate' do
      it 'evaluates its code' do
        dsl = Recipe::DSL.new(env) { throw :recipe_code }
        expect { dsl.evaluate }.to throw_symbol :recipe_code
      end

      it 'returns itself' do
        expect(dsl.evaluate).to eq dsl
      end
    end

    context 'DSL specific methods' do
      subject(:dsl) { Recipe::DSL.new(env, &code).evaluate }

      describe '#env' do
        let(:code) { proc { env.some_message } }

        it 'returns the current environment' do
          expect(env).to receive :some_message
          dsl.evaluate
        end
      end

      describe '#source' do
        let(:filepath)  { fixture_path_for 'recipes/throw' }
        let(:code)      { "source '#{filepath}'" }
        subject(:dsl)   { Recipe::DSL.new(env, code) }

        it 'sources the recipe given as argument' do
          expect { dsl.evaluate }.to throw_symbol :recipe_code
        end
      end

      describe '#target' do
        let(:code) { proc { target 'some_host.example' } }

        it 'registers the target host in the env' do
          expect(env).to receive(:target=).with('some_host.example')
          dsl
        end
      end

      describe '#task' do
        let(:code) { proc { task(:some_task, :some, :arg) { :some_value } } }

        it 'builds a new evaluated task' do
          expect(Task)
            .to receive(:evaluate).with(:some_task, env, :some, :arg) do |&b|
              expect(b.call).to eq :some_value
            end
          dsl
        end

        it 'registers the new task' do
          task = double('task').as_null_object
          allow(Task).to receive(:new) { task }
          expect(dsl.tasks).to include(task)
        end
      end

      describe '#macro' do
        let(:code) { proc { macro(:hello) { echo 'hello' } } }

        it 'defines the new recipe keyword' do
          expect(dsl).to respond_to(:hello)
        end

        context 'when the new keyword is called' do
          let(:code) { proc { macro(:hello) { echo 'hello' }; hello } }

          it 'registers the new task' do
            expect(dsl.tasks.first.actions.first).to be_an Actions::Echo
          end
        end

        context 'when macro takes arguments' do
          let(:code) { proc { macro(:hello) { |e| echo e }; hello :arg } }

          it 'evaluates task code with arguments' do
            expect(dsl.tasks.first.actions.first.arguments.first).to be :arg
          end
        end
      end
    end
  end
end
