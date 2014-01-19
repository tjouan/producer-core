require 'spec_helper'

module Producer::Core
  describe Env do
    subject(:env) { Env.new }

    describe '#initialize' do
      it 'assigns $stdout as the default output' do
        expect(env.output).to be $stdout
      end

      it 'assigns no default target' do
        expect(env.target).not_to be
      end

      context 'when output is given as argument' do
        let(:output)  { double 'output' }
        subject(:env) { described_class.new(output: output) }

        it 'assigns the given output' do
          expect(env.output).to eq output
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
  end
end
