require 'producer/core/testing'

module Producer::Core
  module Testing
    describe MockRemote do
      subject(:remote) { described_class.new('some_host.example') }

      it 'is a remote' do
        expect(remote).to be_a Remote
      end

      describe '#session' do
        it 'raises an error to prevent real session usage' do
          expect { remote.session }.to raise_error RuntimeError
        end
      end

      describe '#execute' do
        context 'dummy echo command' do
          let(:command) { 'echo some arguments' }

          it 'returns command arguments ended by a record separator' do
            expect(remote.execute command).to eq "some arguments\n"
          end
        end

        context 'dummy true command' do
          let(:command) { 'true' }

          it 'returns an empty string' do
            expect(remote.execute(command)).to eq ''
          end
        end

        context 'dummy false command' do
          let(:command) { 'false' }

          it 'raises a RemoteCommandExecutionError' do
            expect { remote.execute(command) }
              .to raise_error RemoteCommandExecutionError
          end
        end

        context 'dummy type command' do
          context 'executable exists' do
            let(:command) { 'type true' }

            it 'returns an empty string' do
              expect(remote.execute(command)).to eq ''
            end
          end

          context 'executable does not exist' do
            let(:command) { 'type some_non_existent_executable' }

            it 'raises a RemoteCommandExecutionError' do
              expect { remote.execute(command) }
                .to raise_error RemoteCommandExecutionError
            end
          end
        end
      end
    end
  end
end
