module Producer::Core
  module Actions
    describe ShellCommand, :env do
      let(:command_args)  { 'hello from remote host' }
      let(:command)       { "echo #{command_args}" }
      let(:arguments)     { [command] }
      subject(:sh)        { described_class.new(env, *arguments) }

      it_behaves_like 'action'

      describe '#setup' do
        context 'when command is missing' do
          let(:command) { nil }

          it 'raises ArgumentError' do
            expect { sh }.to raise_error ArgumentError
          end
        end
      end

      describe '#apply' do
        it 'executes the remote command' do
          expect_execution(command)
          sh.apply
        end

        it 'writes the returned output' do
          sh.apply
          expect(output).to eq "#{command_args}\n"
        end

        context 'when content is written to standard error' do
          let(:command) { "echo #{command_args} >&2" }

          it 'writes errors to given error stream' do
            sh.apply
            expect(error_output).to eq "#{command_args}\n"
          end
        end
      end
    end
  end
end
