require 'spec_helper'

module Producer::Core
  describe Recipe do
    include FixturesHelpers

    let(:code)        { 'nil' }
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
      let(:env) { double('env').as_null_object }

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
        expect(task).to receive(:evaluate).with(env)
        recipe.evaluate(env)
      end
    end
  end
end
