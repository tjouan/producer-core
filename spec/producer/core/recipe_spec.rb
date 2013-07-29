require 'spec_helper'

module Producer::Core
  describe Recipe do
    include FixturesHelpers

    let(:code)        { 'nil' }
    subject(:recipe)  { Recipe.new(code) }

    describe '.from_file' do
      it 'builds a recipe whose code is read from given file path' do
        filepath = fixture_path_for 'recipes/empty.rb'
        recipe = Recipe.from_file(filepath)
        expect(recipe.code).to eq File.read(filepath)
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
        expect(Recipe::DSL).to receive(:new).with(code).and_call_original
        recipe.evaluate
      end
    end


    describe Recipe::DSL do
      subject(:dsl) { Recipe::DSL.new &code }

      describe '#initialize' do
        let(:code) { Proc.new { raise 'error from recipe' } }

        it 'evaluates its code' do
          expect { dsl }.to raise_error(RuntimeError, 'error from recipe')
        end
      end

      describe '#source' do
        let(:code)    { "source '#{fixture_path_for 'recipes/error'}'" }
        subject(:dsl) { Recipe::DSL.new code }

        it 'sources the recipe given as argument' do
          expect { dsl }.to raise_error(RuntimeError, 'error from recipe')
        end
      end

      describe '#tasks' do
        let(:code) { Proc.new { task(:some_task) } }

        it 'returns registered tasks' do
          expect(dsl.tasks[0].name).to eq :some_task
        end
      end

      describe '#task' do
        let(:code) { Proc.new { task(:one); task(:two) } }

        it 'registers tasks in declaration order' do
          expect(dsl.tasks[0].name).to eq :one
          expect(dsl.tasks[1].name).to eq :two
        end
      end
    end
  end
end
