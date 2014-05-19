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
      let(:cli)       { double('cli').as_null_object }
      let(:output)    { StringIO.new }
      subject(:run)   { described_class.run! arguments, output: output }

      it 'builds a new CLI with given arguments' do
        expect(described_class)
          .to receive(:new).with(arguments).and_call_original
        run
      end

      it 'runs the CLI' do
        allow(described_class).to receive(:new) { cli }
        expect(cli).to receive :run
        run
      end

      it 'parses CLI arguments' do
        allow(described_class).to receive(:new) { cli }
        expect(cli).to receive :parse_arguments!
        run
      end

      context 'when an argument error is raised' do
        before do
          allow(CLI).to receive(:new) { cli }
          allow(cli).to receive(:parse_arguments!)
            .and_raise described_class::ArgumentError
        end

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
      it 'assigns the env with CLI output' do
        expect(cli.env.output).to be stdout
      end

      context 'without options' do
        subject(:cli) { CLI.new(arguments) }

        it 'assigns $stdout as the default standard output' do
          expect(cli.stdout).to be $stdout
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

    describe '#parse_arguments!' do
      context 'with options' do
        let(:arguments) { ['-v', recipe_file] }

        before { cli.parse_arguments! }

        it 'removes options from arguments' do
          expect(cli.arguments).to eq [recipe_file]
        end

        context 'verbose' do
          it 'sets env logger level to INFO' do
            expect(cli.env.log_level).to eq Logger::INFO
          end
        end
      end

      context 'without arguments' do
        let(:arguments) { [] }

        it 'raises the argument error exception' do
          expect { cli.parse_arguments! }.to raise_error described_class::ArgumentError
        end
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

    describe '#env' do
      it 'returns an env' do
        expect(cli.env).to be_an Env
      end
    end

    describe '#load_recipe' do
      it 'evaluates the recipe file with the CLI env' do
        expect(Recipe)
          .to receive(:evaluate_from_file).with(recipe_file, cli.env)
        cli.load_recipe
      end

      it 'assigns the evaluated recipe' do
        cli.load_recipe
        expect(cli.recipe.tasks.count).to be 2
      end
    end

    describe '#build_worker' do
      it 'returns a worker' do
        expect(cli.build_worker).to be_a Worker
      end

      it 'assigns the CLI env' do
        expect(cli.build_worker.env).to eq cli.env
      end
    end
  end
end
