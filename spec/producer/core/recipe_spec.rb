require 'spec_helper'

module Producer::Core
  describe Recipe do
    include FixturesHelpers

    subject(:recipe) { Recipe.new }

    describe '.evaluate_from_file' do
      let(:env)         { double 'env' }
      let(:filepath)    { fixture_path_for 'recipes/some_recipe.rb' }
      subject(:recipe)  { Recipe.evaluate_from_file(filepath, env) }

      it 'returns an evaluated recipe' do
        expect(recipe.tasks.map(&:name)).to eq [:some_task, :another_task]
      end
    end

    describe '#initialize' do
      context 'without arguments' do
        it 'assigns no task' do
          expect(recipe.tasks).to be_empty
        end
      end

      context 'when tasks are given as argument' do
        let(:tasks)       { [double('task')] }
        subject(:recipe)  { Recipe.new(tasks) }

        it 'assigns the tasks' do
          expect(recipe.tasks).to eq tasks
        end
      end
    end
  end
end
