require 'spec_helper'

module Producer::Core
  describe Recipe do
    include FixturesHelpers

    let(:env)         { Env.new }
    subject(:recipe)  { described_class.new(env) }

    describe '#initialize' do
      it 'assigns no task' do
        expect(recipe.tasks).to be_empty
      end
    end

    describe '#source' do
      let(:filepath) { fixture_path_for 'recipes/throw' }

      it 'sources the recipe given as argument' do
        expect { recipe.source filepath }.to throw_symbol :recipe_code
      end
    end

    describe '#target' do
      let(:host) { 'some_host.example' }

      context 'when env has no assigned target' do
        it 'registers the target host in the env' do
          recipe.target host
          expect(env.target).to eq host
        end
      end

      context 'when env has an assigned target' do
        before { env.target = 'already_assigned_host.example' }

        it 'does not change env target' do
          expect { recipe.target host }.not_to change { env.target }
        end
      end

      context 'when no arguments are provided' do
        it 'returns current target' do
          recipe.target host
          expect(recipe.target).to eq host
        end
      end
    end

    describe '#task' do
      it 'registers a new evaluated task' do
        expect { recipe.task(:some_task) { :some_task_code } }
          .to change { recipe.tasks.count }.by 1
      end
    end

    describe '#macro' do
      it 'defines the new recipe keyword' do
        recipe.macro(:hello) { }
        expect(recipe).to respond_to(:hello)
      end

      it 'defines the new task keyword' do
        recipe.macro(:hello) { }
        expect { recipe.task(:some_task) { hello } }.not_to raise_error
      end

      context 'when a defined macro is called' do
        before { recipe.macro(:hello) { :some_macro_code } }

        it 'registers the new task' do
          expect { recipe.hello }.to change { recipe.tasks.count }.by 1
        end
      end

      context 'when a defined macro is called with arguments' do
        before { recipe.macro(:hello) { |a, b| echo a, b } }

        it 'evaluates task code with given arguments' do
          recipe.hello :foo, :bar
          expect(recipe.tasks.first.actions.first.arguments).to eq %i[foo bar]
        end
      end
    end

    describe '#test_macro' do
      it 'defines the new test' do
        recipe.test_macro(:some_test) { }
        expect(Condition.new).to respond_to :some_test
      end
    end

    describe '#set' do
      it 'registers a key/value pair in env registry' do
        recipe.set :some_key, :some_value
        expect(env[:some_key]).to eq :some_value
      end
    end

    describe '#get' do
      it 'fetches a value from the registry at given index' do
        recipe.set :some_key, :some_value
        expect(recipe.get :some_key).to eq :some_value
      end
    end
  end
end
