require 'spec_helper'

module Producer::Core
  describe CLI do
    include FixturesHelpers

    let(:arguments) { ['host', fixture_path_for('recipes/empty.rb')] }
    subject(:cli)   { CLI.new(arguments) }

    describe '#initialize' do
      it 'assigns the arguments' do
        expect(cli.arguments).to eq arguments
      end
    end

    # FIXME: spec/method need refactoring
    describe '#run!' do
      it 'builds a recipe' do
        expect(Recipe).to receive(:from_file).with(arguments[1]).and_call_original
        cli.run!
      end

      it 'builds an environment with the current recipe' do
        recipe = double('recipe').as_null_object
        allow(Recipe).to receive(:from_file).and_return(recipe)
        expect(Env).to receive(:new).with(recipe).and_call_original
        cli.run!
      end

      it 'evaluates the recipe with the environment' do
        recipe = double('recipe')
        allow(Recipe).to receive(:from_file).and_return(recipe)
        env = double('env')
        allow(Env).to receive(:new).and_return(env)
        expect(recipe).to receive(:evaluate).with(env)
        cli.run!
      end

      context 'missing argument' do
        let(:arguments) { %w{host} }
        let(:stdout)    { StringIO.new }
        subject(:cli)   { CLI.new(arguments, stdout) }

        it 'exits' do
          expect { cli.run! }.to raise_error(SystemExit) { |e|
            expect(e.status).to eq 64
          }
        end

        it 'prints the usage' do
          begin
            cli.run!
          rescue SystemExit
          end
          expect(stdout.string).to match /\AUsage: .+/
        end
      end
    end
  end
end
