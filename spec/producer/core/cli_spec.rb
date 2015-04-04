require 'spec_helper'

module Producer::Core
  describe CLI do
    include ExitHelpers
    include FixturesHelpers

    let(:options)     { [] }
    let(:recipe_file) { fixture_path_for 'recipes/some_recipe.rb' }
    let(:arguments)   { [*options, recipe_file] }

    subject(:cli)     { described_class.new(arguments) }

    describe '.run!' do
      subject(:run!) { described_class.run! arguments }

      it 'builds a new CLI instance with given arguments' do
        expect(described_class)
          .to receive(:new).with(arguments, anything).and_call_original
        run!
      end

      it 'parses new CLI instance arguments' do
        expect_any_instance_of(described_class).to receive :parse_arguments!
        run!
      end

      it 'runs the new CLI instance' do
        expect_any_instance_of(described_class).to receive :run
        run!
      end

      context 'when no recipe is given' do
        let(:arguments) { [] }

        it 'exits with a return status of 64' do
          expect { described_class.run! arguments, stderr: StringIO.new }
            .to raise_error(SystemExit) { |e| expect(e.status).to eq 64 }
        end

        it 'prints the usage on the error stream' do
          expect { trap_exit { run! } }
            .to output(/\AUsage: .+/).to_stderr
        end
      end

      context 'when an error is raised' do
        let(:recipe_file) { fixture_path_for 'recipes/raise.rb' }

        it 'exits with a return status of 70' do
          expect { described_class.run! arguments, stderr: StringIO.new }
            .to raise_error(SystemExit) { |e| expect(e.status).to eq 70 }
        end

        it 'prints a report to the error stream' do
          expect { trap_exit { run! } }
            .to output(/\ARemoteCommandExecutionError: false$/).to_stderr
        end
      end
    end

    describe '#initialize' do
      it 'assigns an env' do
        expect(cli.env).to be_an Env
      end

      it 'assigns CLI stdin as the env input' do
        expect(cli.env.input).to be cli.stdin
      end

      it 'assigns CLI stdout as the env output' do
        expect(cli.env.output).to be cli.stdout
      end

      it 'assigns CLI stderr as the env error output' do
        expect(cli.env.error_output).to be cli.stderr
      end
    end

    describe '#parse_arguments!' do
      let(:options) { %w[-v -t some_host.example] }

      it 'removes options from arguments' do
        cli.parse_arguments!
        expect(cli.arguments).to eq [recipe_file]
      end

      context 'with verbose option' do
        let(:options) { %w[-v] }

        it 'enables env verbose mode' do
          cli.parse_arguments!
          expect(cli.env).to be_verbose
        end
      end

      context 'with dry run option' do
        let(:options) { %w[-n] }

        it 'enables env dry run mode' do
          cli.parse_arguments!
          expect(cli.env).to be_dry_run
        end
      end

      context 'with target option' do
        let(:options) { %w[-t some_host.example] }

        it 'assigns the given target to the env' do
          cli.parse_arguments!
          expect(cli.env.target).to eq 'some_host.example'
        end
      end

      context 'with debug option' do
        let(:options) { %w[-d] }

        it 'assigns the given target to the env' do
          cli.parse_arguments!
          expect(cli.env).to be_debug
        end
      end

      context 'with combined options' do
        let(:options) { %w[-vn]}

        it 'handles combined options' do
          cli.parse_arguments!
          expect(cli.env).to be_verbose.and be_dry_run
        end
      end

      context 'with recipe arguments' do
        let(:arguments) { %w[recipe.rb -- foo] }

        it 'removes recipe arguments' do
          cli.parse_arguments!
          expect(cli.arguments).to eq %w[recipe.rb]
        end

        it 'assigns env recipe arguments' do
          cli.parse_arguments!
          expect(cli.env.recipe_argv).to eq %w[foo]
        end
      end

      context 'when no arguments remains after parsing' do
        let(:arguments) { [] }

        it 'raises an error' do
          expect { cli.parse_arguments! }
            .to raise_error described_class::ArgumentError
        end
      end
    end

    describe '#run' do
      it 'processes recipes tasks with a worker' do
        worker = instance_spy Worker
        cli.run worker: worker
        expect(worker).to have_received(:process)
          .with all be_an_instance_of Task
      end

      it 'cleans up the env' do
        expect(cli.env).to receive :cleanup
        cli.run
      end

      context 'on error' do
        let(:recipe_file) { fixture_path_for 'recipes/raise.rb' }

        it 'cleans up the env' do
          expect(cli.env).to receive :cleanup
          cli.run rescue nil
        end
      end
    end

    describe '#evaluate_recipes' do
      it 'returns the evaluated recipes' do
        expect(cli.evaluate_recipes).to all be_an_instance_of Recipe
      end
    end
  end
end
