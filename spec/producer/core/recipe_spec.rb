require 'spec_helper'

module Producer::Core
  describe Recipe do
    include FixturesHelpers

    subject(:recipe) { Recipe.new }

    describe '.evaluate_from_file' do
      let(:env)       { double 'env' }
      let(:filepath)  { fixture_path_for 'recipes/empty.rb' }

      it 'delegates to DSL.evaluate with the recipe file content' do
        expect(Recipe::DSL)
          .to receive(:evaluate).with(File.read(filepath), env)
        Recipe.evaluate_from_file(filepath, env)
      end

      it 'returns the evaluated recipe' do
        recipe = double 'recipe'
        allow(Recipe::DSL).to receive(:evaluate) { recipe }
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
