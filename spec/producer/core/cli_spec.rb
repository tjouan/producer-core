require 'spec_helper'

module Producer::Core
  describe CLI do
    let(:arguments) { %w{host recipe.rb} }
    subject(:cli)   { CLI.new(arguments) }

    describe '#initialize' do
      it 'assigns the arguments' do
        expect(cli.arguments).to eq arguments
      end
    end

    describe '#run!' do
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
