require 'spec_helper'

module Producer::Core
  describe CLI do
    include FixturesHelpers

    let(:recipe_file) { fixture_path_for('recipes/empty.rb') }
    let(:arguments)   { [recipe_file] }
    subject(:cli)     { CLI.new(arguments) }

    describe '#initialize' do
      it 'assigns the arguments' do
        expect(cli.arguments).to eq arguments
      end
    end

    describe '#run!' do
      it 'checks the arguments' do
        expect(cli).to receive(:check_arguments!)
        cli.run!
      end

      it 'evaluates the recipe' do
        expect(cli).to receive(:evaluate_recipe_file)
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
        let(:stdout)    { StringIO.new }
        subject(:cli)   { CLI.new(arguments, stdout) }

        it 'exits with a return status of 64' do
          expect { cli.check_arguments! }.to raise_error(SystemExit) { |e|
            expect(e.status).to eq 64
          }
        end

        it 'prints the usage' do
          begin
            cli.check_arguments!
          rescue SystemExit
          end
          expect(stdout.string).to match /\AUsage: .+/
        end
      end
    end

    describe '#evaluate_recipe_file' do
      it 'builds a recipe' do
        expect(Recipe)
          .to receive(:from_file).with(recipe_file).and_call_original
        cli.evaluate_recipe_file
      end

      it 'builds an environment with the current recipe' do
        recipe = double('recipe').as_null_object
        allow(Recipe).to receive(:from_file).and_return(recipe)
        expect(Env).to receive(:new).with(recipe).and_call_original
        cli.evaluate_recipe_file
      end

      it 'evaluates the recipe with the environment' do
        recipe = double('recipe')
        allow(Recipe).to receive(:from_file).and_return(recipe)
        env = double('env')
        allow(Env).to receive(:new).and_return(env)
        expect(recipe).to receive(:evaluate).with(env)
        cli.evaluate_recipe_file
      end

      context 'when recipe evaluation fails' do
        let(:recipe_file) { fixture_path_for('recipes/invalid.rb') }
        let(:stdout)      { StringIO.new }
        subject(:cli)     { CLI.new(arguments, stdout) }

        it 'exits with a return status of 70' do
          expect { cli.evaluate_recipe_file }
            .to raise_error(SystemExit) { |e|
              expect(e.status).to eq 70
            }
        end

        def trap_exit
          yield
        rescue SystemExit
        end

        it 'prints the specific error' do
          trap_exit { cli.evaluate_recipe_file }
          expect(stdout.string).to match(/
            \A
            #{recipe_file}:4:
            .+
            invalid\srecipe\skeyword\s`invalid_keyword'
          /x)
        end

        it 'excludes producer own source code from the error backtrace' do
          trap_exit { cli.evaluate_recipe_file }
          expect(stdout.string).to_not match /\/producer-core\//
        end
      end
    end
  end
end
