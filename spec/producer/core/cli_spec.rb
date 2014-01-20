require 'spec_helper'

module Producer::Core
  describe CLI do
    include ExitHelpers
    include FixturesHelpers

    let(:recipe_file) { fixture_path_for 'recipes/some_recipe.rb' }
    let(:arguments)   { [recipe_file] }
    let(:stdout)      { StringIO.new }

    subject(:cli)     { CLI.new(arguments, stdout: stdout) }

    describe '.run!' do
      let(:output)    { StringIO.new }
      subject(:run)   { described_class.run! arguments, output: output }

      it 'builds a new CLI with given arguments' do
        expect(CLI).to receive(:new).with(arguments).and_call_original
        run
      end

      it 'runs the CLI' do
        cli = double 'cli'
        allow(CLI).to receive(:new) { cli }
        expect(cli).to receive :run
        run
      end

      context 'when recipe argument is missing' do
        let(:arguments) { [] }

        it 'exits with a return status of 64' do
          expect { run }.to raise_error(SystemExit) { |e|
            expect(e.status).to eq 64
          }
        end

        it 'prints the usage' do
          trap_exit { run }
          expect(output.string).to match /\AUsage: .+/
        end
      end
    end

    describe '#initialize' do
      subject(:cli) { CLI.new(arguments) }

      it 'assigns $stdout as the default standard output' do
        expect(cli.stdout).to be $stdout
      end

      context 'without arguments' do
        let(:arguments) { [] }

        it 'raises our ArgumentError exception' do
          expect { cli }.to raise_error described_class::ArgumentError
        end
      end
    end

    describe '#arguments' do
      it 'returns the assigned arguments' do
        expect(cli.arguments).to eq arguments
      end
    end

    describe '#stdout' do
      it 'returns the assigned standard output' do
        expect(cli.stdout).to be stdout
      end
    end

    describe '#run' do
      it 'loads the recipe' do
        cli.run
        expect(cli.recipe).to be_a Recipe
      end

      it 'process recipe tasks with given worker' do
        worker = double 'worker'
        expect(worker).to receive(:process).with [kind_of(Task), kind_of(Task)]
        cli.run worker: worker
      end
    end

    describe '#load_recipe' do
      it 'evaluates the recipe file with an env' do
        expect(Recipe)
          .to receive(:evaluate_from_file).with(recipe_file, kind_of(Env))
        cli.load_recipe
      end

      it 'assigns the evaluated recipe' do
        cli.load_recipe
        expect(cli.recipe.tasks.count).to be 2
      end
    end
  end
end
