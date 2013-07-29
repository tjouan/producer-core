require 'spec_helper'

module Producer::Core
  describe Recipe do
    include FixturesHelpers

    let(:code)        { 'nil' }
    let(:env)         { double('env') }
    subject(:recipe)  { Recipe.new(code) }

    describe '.from_file' do
      let (:filepath)   { fixture_path_for 'recipes/empty.rb' }
      subject(:recipe)  { Recipe.from_file(filepath) }

      it 'builds a recipe whose code is read from given file path' do
        expect(recipe.code).to eq File.read(filepath)
      end

      it 'builds a recipe whose file path is set from given file path' do
        expect(recipe.filepath).to eq filepath
      end
    end

    describe '#initialize' do
      it 'builds a recipe' do
        expect(recipe).to be_a Recipe
      end
    end

    describe '#code' do
      it 'returns the assigned code' do
        expect(recipe.code).to eq code
      end
    end

    describe '#evaluate' do
      it 'builds a recipe DSL sandbox' do
        expect(Recipe::DSL).to receive(:new).once.with(code).and_call_original
        recipe.evaluate(env)
      end

      it 'evaluates the DSL sandbox with the environment given as argument' do
        dsl = double('dsl').as_null_object
        allow(Recipe::DSL).to receive(:new) { dsl }
        expect(dsl).to receive(:evaluate)
        recipe.evaluate(env)
      end

      it 'evaluates the DSL sandbox tasks' do
        task = double('task')
        allow(Task).to receive(:new) { task }
        dsl = Recipe::DSL.new { task(:some_task) }
        allow(Recipe::DSL).to receive(:new) { dsl }
        expect(task).to receive(:evaluate)
        recipe.evaluate(env)
      end
    end


    describe Recipe::DSL do
      let(:code)    { Proc.new { } }
      subject(:dsl) { Recipe::DSL.new &code }

      describe '#initialize' do
        context 'when a string of code is given as argument' do
          subject(:dsl) { Recipe::DSL.new 'nil' }

          it 'returns the DSL instance' do
            expect(dsl).to be_a Recipe::DSL
          end
        end

        context 'when a code block is given as argument' do
          subject(:dsl) { Recipe::DSL.new Proc.new { } }

          it 'returns the DSL instance' do
            expect(dsl).to be_a Recipe::DSL
          end
        end
      end

      describe '#evaluate' do
        it 'evaluates its code' do
          dsl = Recipe::DSL.new { raise 'error from recipe' }
          expect { dsl.evaluate(env) }.to raise_error(RuntimeError, 'error from recipe')
        end

        it 'returns itself' do
          expect(dsl.evaluate(env)).to eq dsl
        end
      end

      context 'DSL specific methods' do
        subject(:dsl) { Recipe::DSL.new(&code).evaluate(env) }

        describe '#source' do
          let(:code)    { "source '#{fixture_path_for 'recipes/error'}'" }
          subject(:dsl) { Recipe::DSL.new code }

          it 'sources the recipe given as argument' do
            expect { dsl.evaluate(env) }.to raise_error(RuntimeError, 'error from recipe')
          end
        end

        describe '#tasks' do
          let(:code) { Proc.new { task(:some_task) } }

          it 'returns registered tasks' do
            expect(dsl.tasks[0].name).to eq :some_task
          end
        end

        describe '#task' do
          let(:code) { Proc.new { task(:first); task(:last) } }

          it 'registers tasks in declaration order' do
            expect(dsl.tasks[0].name).to eq :first
            expect(dsl.tasks[1].name).to eq :last
          end
        end
      end
    end
  end
end
