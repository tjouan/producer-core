require 'spec_helper'

module Producer::Core
  describe CLI do
    include ExitHelpers
    include FixturesHelpers

    let(:recipe_file) { fixture_path_for 'recipes/some_recipe.rb' }
    let(:options)     { [] }
    let(:arguments)   { [*options, recipe_file] }

    subject(:cli)     { described_class.new(arguments) }

    describe '.run!' do
      let(:stderr)    { StringIO.new }
      subject(:run!)  { described_class.run! arguments, stderr: stderr }

      context 'when given arguments are invalid' do
        let(:arguments) { [] }

        it 'exits with a return status of 64' do
          expect { run! }.to raise_error(SystemExit) do |e|
            expect(e.status).to eq 64
          end
        end

        it 'prints the usage on the error stream' do
          trap_exit { run! }
          expect(stderr.string).to match /\AUsage: .+/
        end
      end

      context 'when a runtime error is raised' do
        let(:recipe_file) { fixture_path_for 'recipes/raise.rb' }

        it 'exits with a return status of 70' do
          expect { run! }.to raise_error(SystemExit) do |e|
            expect(e.status).to eq 70
          end
        end

        it 'prints exception name and message and the error stream' do
          trap_exit { run! }
          expect(stderr.string).to eq "RemoteCommandExecutionError: false\n"
        end
      end
    end

    describe '#env' do
      let(:stdin)   { StringIO.new }
      let(:stdout)  { StringIO.new }
      let(:stderr)  { StringIO.new }

      subject(:cli) { described_class.new(arguments,
                        stdin: stdin, stdout: stdout, stderr: stderr) }

      it 'returns an env' do
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
      it 'processes recipe tasks with a worker' do
        worker = instance_spy Worker
        cli.run worker: worker
        expect(worker).to have_received(:process).with cli.recipe.tasks
      end

      it 'cleans up the env' do
        expect(cli.env).to receive :cleanup
        cli.run
      end
    end

    describe '#recipe' do
      it 'returns the evaluated recipe' do
        expect(cli.recipe.tasks).to match [
          an_object_having_attributes(name: :some_task),
          an_object_having_attributes(name: :another_task)
        ]
      end
    end
  end
end
