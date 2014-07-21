require 'spec_helper'

module Producer::Core
  describe CLI do
    include ExitHelpers
    include FixturesHelpers

    let(:recipe_file) { fixture_path_for 'recipes/some_recipe.rb' }
    let(:options)     { [] }
    let(:arguments)   { [*options, recipe_file] }
    let(:stdin)       { StringIO.new}
    let(:stdout)      { StringIO.new }
    let(:stderr)      { StringIO.new }

    subject(:cli)     { described_class.new(
                          arguments,
                          stdin: stdin, stdout: stdout, stderr: stderr) }

    describe '.run!' do
      let(:cli) { double('cli').as_null_object }

      subject(:run) do
        described_class.run! arguments,
          stdin:  stdin,
          stdout: stdout,
          stderr: stderr
      end

      before { allow(described_class).to receive(:new) { cli } }

      it 'builds a new CLI with given arguments and streams' do
        expect(described_class).to receive(:new).with(arguments,
          stdin:  stdin,
          stdout: stdout,
          stderr: stderr
        )
        run
      end

      it 'runs the CLI' do
        expect(cli).to receive :run
        run
      end

      it 'parses CLI arguments' do
        expect(cli).to receive :parse_arguments!
        run
      end

      context 'when an argument error is raised' do
        before do
          allow(cli).to receive(:parse_arguments!)
            .and_raise described_class::ArgumentError
        end

        it 'exits with a return status of 64' do
          expect { run }.to raise_error(SystemExit) do |e|
            expect(e.status).to eq 64
          end
        end

        it 'prints the usage on the error stream' do
          trap_exit { run }
          expect(stderr.string).to match /\AUsage: .+/
        end
      end

      context 'when a runtime error is raised' do
        before do
          allow(cli).to receive(:run)
            .and_raise RuntimeError, 'some message'
        end

        it 'exits with a return status of 70' do
          expect { run }.to raise_error(SystemExit) do |e|
            expect(e.status).to eq 70
          end
        end

        it 'prints exception name and message and the error stream' do
          trap_exit { run }
          expect(stderr.string).to match /\ARuntimeError: some message/
        end
      end
    end

    describe '#initialize' do
      subject(:cli) { described_class.new(arguments) }

      it 'assigns $stdin as the default standard input' do
        expect(cli.stdin).to be $stdin
      end

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

    describe '#env' do
      it 'returns the assigned env' do
        expect(cli.env).to be_an Env
      end

      it 'assigns CLI stdin as the env input' do
        expect(cli.env.input).to be stdin
      end

      it 'assigns CLI stdout as the env output' do
        expect(cli.env.output).to be stdout
      end

      it 'assigns CLI stderr as the env error output' do
        expect(cli.env.error_output).to be stderr
      end
    end

    describe '#parse_arguments!' do
      context 'with options' do
        let(:options) { %w[-v -t some_host.example] }

        before { cli.parse_arguments! }

        it 'removes options from arguments' do
          expect(cli.arguments).to eq [recipe_file]
        end

        context 'verbose' do
          let(:options) { %w[-v] }

          it 'enables env verbose mode' do
            expect(cli.env).to be_verbose
          end
        end

        context 'dry run' do
          let(:options) { %w[-n] }

          it 'enables env dry run mode' do
            expect(cli.env).to be_dry_run
          end
        end

        context 'target' do
          let(:options) { %w[-t some_host.example] }

          it 'assigns the given target to the env' do
            expect(cli.env.target).to eq 'some_host.example'
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
      it 'process recipe tasks with given worker' do
        worker = double 'worker'
        allow(cli).to receive(:worker) { worker }
        expect(worker).to receive(:process)
          .with([an_instance_of(Task), an_instance_of(Task)])
        cli.run
      end

      it 'cleans up the env' do
        expect(cli.env).to receive :cleanup
        cli.run
      end
    end

    describe '#load_recipe' do
      it 'evaluates the recipe file with the CLI env' do
        expect(Recipe)
          .to receive(:evaluate_from_file).with(recipe_file, cli.env)
        cli.load_recipe
      end

      it 'returns the recipe' do
        expect(cli.load_recipe).to be_a Recipe
      end
    end

    describe '#worker' do
      it 'returns a worker' do
        expect(cli.worker).to be_a Worker
      end

      it 'assigns the CLI env' do
        expect(cli.worker.env).to eq cli.env
      end
    end
  end
end
