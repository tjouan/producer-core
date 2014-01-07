require 'spec_helper'

module Producer::Core
  describe CLI do
    include ExitHelpers
    include FixturesHelpers

    let(:recipe_file) { fixture_path_for 'recipes/empty.rb' }
    let(:arguments)   { [recipe_file] }
    let(:stdout)      { StringIO.new }

    subject(:cli)     { CLI.new(arguments, stdout: stdout) }

    describe '#initialize' do
      subject(:cli) { CLI.new(arguments) }

      it 'assigns $stdout as the default standard output' do
        expect(cli.stdout).to be $stdout
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

    describe '#run!' do
      it 'checks the arguments' do
        expect(cli).to receive :check_arguments!
        cli.run!
      end

      it 'processes the tasks with the interpreter' do
        allow(cli.recipe).to receive(:tasks) { [:some_task] }
        expect(cli.interpreter).to receive(:process).with [:some_task]
        cli.run!
      end
    end

    describe '#check_arguments!' do
      context 'when recipe argument is provided' do
        it 'does not raise any error' do
          expect { cli.check_arguments! }.to_not raise_error
        end
      end

      context 'when recipe argument is missing' do
        let(:arguments) { [] }

        it 'exits with a return status of 64' do
          expect { cli.check_arguments! }.to raise_error(SystemExit) { |e|
            expect(e.status).to eq 64
          }
        end

        it 'prints the usage' do
          trap_exit { cli.check_arguments! }
          expect(stdout.string).to match /\AUsage: .+/
        end
      end
    end

    describe '#env' do
      it 'builds an environment with the current recipe' do
        expect(Env).to receive :new
        cli.env
      end

      it 'returns the env' do
        env = double 'env'
        allow(Env).to receive(:new) { env }
        expect(cli.env).to be env
      end
    end

    describe '#recipe' do
      it 'builds a recipe' do
        expect(Recipe)
          .to receive(:evaluate_from_file).with(recipe_file, cli.env)
        cli.recipe
      end

      it 'returns the recipe' do
        recipe = double('recipe').as_null_object
        allow(Recipe).to receive(:new) { recipe }
        expect(cli.recipe).to be recipe
      end
    end

    describe '#interpreter' do
      it 'builds a interpreter' do
        expect(Interpreter).to receive :new
        cli.interpreter
      end

      it 'returns the interpreter' do
        interpreter = double 'interpreter'
        allow(Interpreter).to receive(:new) { interpreter }
        expect(cli.interpreter).to be interpreter
      end
    end
  end
end
