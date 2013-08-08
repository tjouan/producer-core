require 'spec_helper'

module Producer::Core
  describe CLI do
    include ExitHelpers
    include FixturesHelpers

    let(:recipe_file) { fixture_path_for('recipes/empty.rb') }
    let(:arguments)   { [recipe_file] }
    subject(:cli)     { CLI.new(arguments) }

    describe '#initialize' do
      it 'assigns $stdout as the default standard output' do
        expect(cli.instance_eval { @stdout }).to be $stdout
      end
    end

    describe '#arguments' do
      it 'returns the assigned arguments' do
        expect(cli.arguments).to eq arguments
      end
    end

    describe '#run!' do
      it 'checks the arguments' do
        expect(cli).to receive(:check_arguments!)
        cli.run!
      end

      it 'evaluates the recipe with the environment' do
        expect(cli.recipe).to receive(:evaluate).with(cli.env)
        cli.run!
      end

      it 'processes the tasks with the worker' do
        allow(cli.recipe).to receive(:tasks) { [:some_task] }
        expect(cli.worker).to receive(:process).with([:some_task])
        cli.run!
      end

      context 'when recipe evaluation fails' do
        let(:recipe_file) { fixture_path_for('recipes/invalid.rb') }
        let(:stdout)      { StringIO.new }
        subject(:cli)     { CLI.new(arguments, stdout) }

        context 'when error is known' do
          it 'exits with a return status of 70' do
            expect { cli.run! }
              .to raise_error(SystemExit) { |e|
                expect(e.status).to eq 70
              }
          end

          it 'prints the specific error' do
            trap_exit { cli.run! }
            expect(stdout.string).to match(/
              \A
              #{recipe_file}:4:
              .+
              invalid\srecipe\skeyword\s`invalid_keyword'
            /x)
          end

          it 'excludes producer own source code from the error backtrace' do
            trap_exit { cli.run! }
            expect(stdout.string).to_not match /\/producer-core\//
          end
        end

        context 'when error is unknown (unexpected)' do
          it 'lets the error be' do
            UnexpectedError = Class.new(StandardError)
            allow(cli.recipe).to receive(:evaluate).and_raise(UnexpectedError)
            expect { cli.run! }.to raise_error(UnexpectedError)
          end
        end
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
        let(:stdout)    { StringIO.new }
        subject(:cli)   { CLI.new(arguments, stdout) }

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
        expect(Env).to receive(:new).with(cli.recipe)
        cli.env
      end

      it 'returns the env' do
        env = double('env')
        allow(Env).to receive(:new) { env }
        expect(cli.env).to be env
      end
    end

    describe '#recipe' do
      it 'builds a recipe' do
        expect(Recipe)
          .to receive(:from_file).with(recipe_file)
        cli.recipe
      end

      it 'returns the recipe' do
        recipe = double('recipe')
        allow(Recipe).to receive(:new) { recipe }
        expect(cli.recipe).to be recipe
      end
    end

    describe '#worker' do
      it 'builds a worker' do
        expect(Worker).to receive(:new)
        cli.worker
      end

      it 'returns the worker' do
        worker = double('worker')
        allow(Worker).to receive(:new) { worker }
        expect(cli.worker).to be worker
      end
    end
  end
end
