require 'spec_helper'

module Producer::Core
  describe Env do
    subject(:env) { Env.new }

    describe '#initialize' do
      it 'assigns $stdout as the default output' do
        expect(env.instance_eval { @output }).to eq $stdout
      end

      it 'assigns no default target' do
        expect(env.target).not_to be
      end
    end

    describe '#output' do
      let(:stdout) { StringIO.new }

      it 'writes the given string to the assigned IO with a record separator' do
        env.output = stdout
        env.output 'some content'
        expect(stdout.string).to eq "some content\n"
      end
    end

    describe '#target' do
      let(:target) { Object.new }

      it 'returns the defined target' do
        env.target = target
        expect(env.target).to eq target
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
