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
    end
  end
end
