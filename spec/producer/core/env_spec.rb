require 'spec_helper'

module Producer::Core
  describe Env do
    let(:recipe)  { Recipe.new(proc { nil }) }
    subject(:env) { Env.new(recipe) }

    describe '#initialize' do
      it 'has no target' do
        expect(env.target).not_to be
      end
    end

    describe '#current_recipe' do
      it 'returns the assigned current recipe' do
        expect(env.current_recipe).to eq recipe
      end
    end

    describe '#target' do
      let(:target) { Object.new }

      it 'returns the defined target' do
        env.target = target
        expect(env.target).to eq target
      end
    end
  end
end
