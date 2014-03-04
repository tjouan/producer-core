require 'spec_helper'
require 'producer/core/testing'

module Producer::Core
  module Testing
    describe MockRemote do
      subject(:remote) { MockRemote.new('some_host.example') }

      it 'is a remote' do
        expect(remote).to be_a Remote
      end

      describe '#session' do
        it 'raises an error to prevent real session usage' do
          expect { remote.session }.to raise_error
        end
      end

      describe '#execute' do
        context 'dummy echo command' do
          let(:command) { 'echo some arguments' }

          it 'returns command arguments' do
            expect(remote.execute(command)).to eq 'some arguments'
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
            expect { remote.execute(command) }.to raise_error(RemoteCommandExecutionError)
          end
        end
      end
    end
  end
end
