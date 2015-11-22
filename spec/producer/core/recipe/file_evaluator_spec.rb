module Producer::Core
  class Recipe
    describe FileEvaluator do
      include FixturesHelpers

      describe '.evaluate' do
        let(:env)         { Env.new }
        let(:file_path)   { fixture_path_for 'recipes/some_recipe.rb' }
        subject(:recipe)  { described_class.evaluate(file_path, env) }

        it 'returns an evaluated recipe' do
          expect(recipe.tasks).to match [
            an_object_having_attributes(name: :some_task),
            an_object_having_attributes(name: :another_task)
          ]
        end
      end
    end
  end
end
