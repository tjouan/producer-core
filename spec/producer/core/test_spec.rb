require 'spec_helper'

module Producer::Core
  describe Test do
    let(:env)         { Env.new }
    let(:arguments)   { [:some, :arguments] }
    subject(:test)    { Test.new(env, *arguments) }

    describe '#initialize' do
      it 'assigns the env' do
        expect(test.env).to be env
      end

      it 'assigns the arguments' do
        expect(test.arguments).to eq arguments
      end

      it 'assigns negated as false by default' do
        expect(test).to_not be_negated
      end

      context 'when negated option is true' do
        subject(:test) { described_class.new(env, *arguments, negated: true) }

        it 'assigns negated as true' do
          expect(test).to be_negated
        end
      end
    end

    describe '#remote' do
      it 'returns env remote' do
        expect(test.remote).to be test.env.remote
      end
    end

    describe '#fs' do
      it 'returns env remote fs' do
        expect(test.fs).to be test.env.remote.fs
      end
    end

    describe '#negated?' do
      it 'returns false' do
        expect(test.negated?).to be false
      end

      context 'when test is negated' do
        subject(:test) { described_class.new(env, *arguments, negated: true) }

        it 'returns true' do
          expect(test.negated?).to be true
        end
      end
    end

    describe '#pass?' do
      it 'returns true when #verify is true' do
        allow(test).to receive(:verify) { true }
        expect(test.pass?).to be true
      end

      it 'returns false when #verify is false' do
        allow(test).to receive(:verify) { false }
        expect(test.pass?).to be false
      end

      context 'when test is negated' do
        subject(:test) { described_class.new(env, *arguments, negated: true) }

        it 'returns false when #verify is true' do
          allow(test).to receive(:verify) { true }
          expect(test.pass?).to be false
        end

        it 'returns true when #verify is false' do
          allow(test).to receive(:verify) { false }
          expect(test.pass?).to be true
        end
      end
    end
  end
end
