require 'spec_helper'

module Producer::Core
  describe Env do
    subject(:env) { Env.new }

    describe '#initialize' do
      it 'assigns $stdin as the default output' do
        expect(env.input).to be $stdin
      end

      it 'assigns $stdout as the default output' do
        expect(env.output).to be $stdout
      end

      it 'assigns no default target' do
        expect(env.target).not_to be
      end

      it 'assigns an empty registry' do
        expect(env.registry).to be_empty
      end

      context 'when input is given as argument' do
        let(:input)   { double 'input' }
        subject(:env) { described_class.new(input: input) }

        it 'assigns the given input' do
          expect(env.input).to be input
        end
      end

      context 'when output is given as argument' do
        let(:output)  { double 'output' }
        subject(:env) { described_class.new(output: output) }

        it 'assigns the given output' do
          expect(env.output).to be output
        end
      end

      context 'when remote is given as argument' do
        let(:remote)  { double 'remote' }
        subject(:env) { described_class.new(remote: remote) }

        it 'assigns the given remote' do
          expect(env.remote).to be remote
        end
      end
    end

    describe '#target' do
      let(:target) { double 'target' }

      it 'returns the defined target' do
        env.target = target
        expect(env.target).to be target
      end
    end

    describe '#remote' do
      it 'builds a Remote with the current target' do
        env.target = 'some_hostname.example'
        expect(Remote).to receive(:new).with(env.target)
        env.remote
      end

      it 'returns the remote' do
        remote = double 'remote'
        allow(Remote).to receive(:new) { remote }
        expect(env.remote).to eq remote
      end

      it 'memoizes the remote' do
        expect(env.remote).to be env.remote
      end
    end

    describe '#[]' do
      subject(:env) { Env.new(registry: { some_key: :some_value }) }

      it 'returns the value indexed by given key from the registry' do
        expect(env[:some_key]).to eq :some_value
      end
    end

    describe '#[]=' do
      it 'registers given value at given index in the registry' do
        env[:some_key] = :some_value
        expect(env[:some_key]).to eq :some_value
      end
    end
  end
end
