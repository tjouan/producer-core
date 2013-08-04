require 'spec_helper'

module Producer::Core
  describe Env do
    subject(:env) { Env.new }

    describe '#initialize' do
      it 'has no target' do
        expect(env.target).not_to be
      end

      context 'without argument' do
        it 'has no recipe' do
          expect(env.current_recipe).not_to be
        end
      end

      context 'when a recipe is given as argument' do
        let(:recipe)  { Recipe.new(proc { nil }) }
        subject(:env) { Env.new(recipe) }

        it 'assigns the current recipe' do
          expect(env.current_recipe).to eq recipe
        end
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
