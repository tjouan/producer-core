require 'spec_helper'

module Producer::Core
  describe Recipe::DSL do
    include FixturesHelpers

    # Specific error thrown in the error fixture recipe, we can't define it in
    # the recipe, rspec wouldn't know about it.
    SomeErrorInRecipe = Class.new(RuntimeError)

    let(:code)    { proc { } }
    let(:env)     { double('env').as_null_object }
    subject(:dsl) { Recipe::DSL.new &code }

    describe '#initialize' do
      context 'when a string of code is given as argument' do
        subject(:dsl) { Recipe::DSL.new 'nil' }

        it 'returns the DSL instance' do
          expect(dsl).to be_a Recipe::DSL
        end
      end

      context 'when a code block is given as argument' do
        subject(:dsl) { Recipe::DSL.new proc { } }

        it 'returns the DSL instance' do
          expect(dsl).to be_a Recipe::DSL
        end
      end
    end

    describe '#tasks' do
      let(:code) { proc { task(:some_task) } }

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

      context 'when recipe is invalid' do
        let(:filepath)  { fixture_path_for 'recipes/error.rb' }
        let(:recipe)    { Recipe.from_file(filepath) }
        subject(:dsl)   { Recipe::DSL.new File.read(filepath) }

        it 'reports the recipe file path in the error' do
          allow(env).to receive(:current_recipe) { recipe }
          expect { dsl.evaluate(env) }.to raise_error(SomeErrorInRecipe) { |e|
            expect(e.backtrace.first).to match /\A#{filepath}/
          }
        end

        it 'raises a RecipeEvaluationError on NameError' do
          dsl = Recipe::DSL.new { invalid_keyword }
          expect { dsl.evaluate(env) }.to raise_error(RecipeEvaluationError)
        end
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
        subject(:dsl)   { Recipe::DSL.new code }

        it 'sources the recipe given as argument' do
          expect { dsl.evaluate(env) }.to throw_symbol :recipe_code
        end

        context 'when sourced recipe is invalid' do
          let(:filepath) { fixture_path_for 'recipes/error' }

          it 'reports its file path in the error' do
            expect { dsl.evaluate(env) }.to raise_error(SomeErrorInRecipe) { |e|
              expect(e.backtrace.first).to match /\A#{filepath}/
            }
          end
        end
      end

      describe '#target' do
        let(:code) { proc { target 'some_host.example' } }

        it 'registers the target host in the env' do
          expect(env).to receive(:target=).with('some_host.example')
          dsl.evaluate(env)
        end
      end

      describe '#task' do
        let(:code) { proc { task(:first) { throw :first_task }; task(:last) } }

        it 'register a task with its code' do
          expect(dsl.tasks.first.name).to eq :first
          expect { dsl.tasks.first.evaluate(env) }.to throw_symbol :first_task
        end

        it 'registers tasks in declaration order' do
          expect(dsl.tasks[0].name).to eq :first
          expect(dsl.tasks[1].name).to eq :last
        end
      end
    end
  end
end
