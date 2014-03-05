require 'spec_helper'

module Producer::Core
  module Actions
    describe ShellCommand, :env do
      let(:command_args)  { 'hello from remote host' }
      let(:command)       { "echo #{command_args}" }
      subject(:sh)        { ShellCommand.new(env, command) }

      it_behaves_like 'action'

      describe '#apply' do
        it 'executes the remote command' do
          expect_execution(command)
          sh.apply
        end

        it 'writes the returned output' do
          sh.apply
          expect(output).to eq "#{command_args}\n"
        end
      end
    end
  end
end
