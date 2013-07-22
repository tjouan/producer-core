require 'spec_helper'

module Producer::Core
  describe Recipe do
    include FixturesHelpers

    let(:code)        { 'some ruby code' }
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
      let(:message) { 'error from recipe' }
      let(:code)    { "raise '#{message}'" }

      it 'evaluates its code' do
        expect { recipe.evaluate }.to raise_error(RuntimeError, 'error from recipe')
      end
    end
  end
end
