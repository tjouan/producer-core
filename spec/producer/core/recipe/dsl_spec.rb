require 'spec_helper'

module Producer::Core
  describe Recipe::DSL do
    include FixturesHelpers

    let(:code)    { proc { } }
    let(:env)     { double('env').as_null_object }
    subject(:dsl) { Recipe::DSL.new(&code) }

    describe '.evaluate' do
      let(:code) { 'nil' }

      it 'builds a new DSL sandbox with given code' do
        expect(Recipe::DSL).to receive(:new).with(code).and_call_original
        Recipe::DSL.evaluate(code, env)
      end

      it 'evaluates the DSL sandbox code with given environment' do
        dsl = double('dsl').as_null_object
        allow(Recipe::DSL).to receive(:new) { dsl }
        expect(dsl).to receive(:evaluate).with(env)
        Recipe::DSL.evaluate(code, env)
      end

      it 'builds a recipe with evaluated tasks' do
        dsl = Recipe::DSL.new('task(:some_task) { }')
        allow(Recipe::DSL).to receive(:new) { dsl }
        expect(Recipe).to receive(:new).with(dsl.tasks)
        Recipe::DSL.evaluate(code, env)
      end

      it 'returns the recipe' do
        recipe = double('recipe').as_null_object
        allow(Recipe).to receive(:new) { recipe }
        expect(Recipe::DSL.evaluate(code, env)).to be recipe
      end
    end

    describe '#initialize' do
      it 'assigns no task' do
        expect(dsl.instance_eval { @tasks }).to be_empty
      end

      context 'when a string of code is given as argument' do
        let(:code)    { 'some_code' }
        subject(:dsl) { Recipe::DSL.new(code) }

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
        dsl.evaluate(env)
        expect(dsl.tasks[0].name).to eq :some_task
      end
    end

    describe '#evaluate' do
      it 'evaluates its code' do
        dsl = Recipe::DSL.new { throw :recipe_code }
        expect { dsl.evaluate(env) }.to throw_symbol :recipe_code
      end

      it 'returns itself' do
        expect(dsl.evaluate(env)).to eq dsl
      end
    end

    context 'DSL specific methods' do
      subject(:dsl) { Recipe::DSL.new(&code).evaluate(env) }

      describe '#env' do
        let(:code) { proc { env.some_message } }

        it 'returns the current environment' do
          expect(env).to receive(:some_message)
          dsl.evaluate(env)
        end
      end

      describe '#source' do
        let(:filepath)  { fixture_path_for 'recipes/throw' }
        let(:code)      { "source '#{filepath}'" }
        subject(:dsl)   { Recipe::DSL.new(code) }

        it 'sources the recipe given as argument' do
          expect { dsl.evaluate(env) }.to throw_symbol :recipe_code
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
        let(:code) { proc { task(:some_task) { :some_value } } }

        it 'builds a new evaluated task' do
          expect(Task)
            .to receive(:evaluate).with(:some_task, env) do |&block|
              expect(block.call).to eq :some_value
            end
          dsl
        end

        it 'registers the new task' do
          task = double('task').as_null_object
          allow(Task).to receive(:new) { task }
          expect(dsl.tasks).to include(task)
        end
      end
    end
  end
end
