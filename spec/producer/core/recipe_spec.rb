require 'spec_helper'

module Producer::Core
  describe Recipe do
    include FixturesHelpers

    subject(:recipe) { Recipe.new }

    describe '.evaluate_from_file' do
      let(:env)       { double 'env' }
      let(:filepath)  { fixture_path_for 'recipes/empty.rb' }
      let(:code)      { File.read(filepath) }

      it 'builds a new DSL sandbox with code read from given file path' do
        expect(Recipe::DSL).to receive(:new).with(code).and_call_original
        Recipe.evaluate_from_file(filepath, env)
      end

      it 'evaluates the DSL sandbox code with given environment' do
        dsl = double('dsl').as_null_object
        allow(Recipe::DSL).to receive(:new) { dsl }
        expect(dsl).to receive(:evaluate).with(env)
        Recipe.evaluate_from_file(filepath, env)
      end

      it 'builds a recipe with evaluated tasks' do
        dsl = Recipe::DSL.new { task(:some_task) { } }
        allow(Recipe::DSL).to receive(:new) { dsl }
        expect(Recipe).to receive(:new).with(dsl.tasks)
        Recipe.evaluate_from_file(filepath, env)
      end

      it 'returns the recipe' do
        recipe = double('recipe').as_null_object
        allow(Recipe).to receive(:new) { recipe }
        expect(Recipe.evaluate_from_file(filepath, env)).to be recipe
      end

    end

    describe '#initialize' do
      context 'without arguments' do
        it 'assigns no task' do
          expect(recipe.tasks).to be_empty
        end
      end

      context 'when tasks are given as argument' do
        let(:tasks)   { [Task.new(:some_task)] }
        let(:recipe)  { Recipe.new(tasks) }

        it 'assigns the tasks' do
          expect(recipe.tasks).to eq tasks
        end
      end
    end
  end
end
