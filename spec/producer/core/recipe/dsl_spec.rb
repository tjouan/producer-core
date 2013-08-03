require 'spec_helper'

module Producer::Core
  describe Recipe::DSL do
    include FixturesHelpers

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

      describe '#tasks' do
        let(:code) { proc { task(:some_task) } }

        it 'returns registered tasks' do
          expect(dsl.tasks[0].name).to eq :some_task
        end
      end

      describe '#task' do
        let(:code) { proc { task(:first); task(:last) } }

        it 'registers tasks in declaration order' do
          expect(dsl.tasks[0].name).to eq :first
          expect(dsl.tasks[1].name).to eq :last
        end
      end
    end
  end
end
