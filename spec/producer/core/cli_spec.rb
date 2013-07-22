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

    describe '#run!' do
      it 'builds a recipe' do
        expect(Recipe).to receive(:from_file).with(arguments[1]).and_call_original
        cli.run!
      end

      it 'evaluates the recipe' do
        recipe = double('recipe')
        allow(Recipe).to receive(:from_file).and_return(recipe)
        expect(recipe).to receive(:evaluate)
        cli.run!
      end

      context 'missing argument' do
        let(:arguments) { %w{host} }
        let(:stdout)    { StringIO.new }
        subject(:cli)   { CLI.new(arguments, stdout) }

        it 'exits' do
          expect { cli.run! }.to raise_error SystemExit
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
