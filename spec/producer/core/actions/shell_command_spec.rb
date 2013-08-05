require 'spec_helper'

module Producer::Core
  describe Actions::ShellCommand do
    let(:env)           { Env.new }
    let(:command_args)  { 'hello from remote host'}
    let(:command)       { "echo #{command_args}" }
    subject(:sh)        { Actions::ShellCommand.new(env, command) }

    describe '#apply' do
      before do
        env.output = StringIO.new
      end

      it 'delegates the call to env.remote.execute method' do
        expect(env.remote).to receive(:execute).with(command)
        sh.apply
      end

      it 'forwards the returned output to env.output' do
        allow(env.remote).to receive(:execute) { command_args }
        expect(env).to receive(:output).with(command_args)
        sh.apply
      end
    end
  end
end
