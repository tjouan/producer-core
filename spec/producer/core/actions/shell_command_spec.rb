require 'spec_helper'

module Producer::Core
  describe Actions::ShellCommand do
    let(:env)           { Env.new(output: StringIO.new) }
    let(:command_args)  { 'hello from remote host' }
    let(:command)       { "echo #{command_args}" }
    subject(:sh)        { Actions::ShellCommand.new(env, command) }

    describe '#apply' do
      it 'executes the remote command' do
        expect(sh.remote).to receive(:execute).with(command)
        sh.apply
      end

      it 'writes the returned output with a record separator' do
        allow(sh.remote).to receive(:execute) { command_args }
        sh.apply
        expect(sh.output.string).to eq "#{command_args}\n"
      end
    end
  end
end
