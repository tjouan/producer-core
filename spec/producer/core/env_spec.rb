require 'spec_helper'

module Producer::Core
  describe Env do
    let(:recipe)  { Recipe.new(proc { nil }) }
    subject(:env) { Env.new(recipe) }

    describe '#current_recipe' do
      it 'returns the assigned current recipe' do
        expect(env.current_recipe).to eq recipe
      end
    end
  end
end
