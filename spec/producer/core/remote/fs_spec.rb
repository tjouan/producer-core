require 'spec_helper'

module Producer::Core
  describe Remote::FS do
    let(:remote)  { Remote.new('some_host.example') }
    subject(:fs)  { Remote::FS.new(remote) }

    describe '#new' do
      it 'assigns the remote given as argument' do
        expect(fs.instance_eval { @remote }).to be remote
      end
    end

    describe '#sftp', :ssh do
      before { sftp_story }

      it 'builds a new SFTP session' do
        expect(remote.session.sftp).to receive(:connect)
        fs.sftp
      end

      it 'returns the new SFTP session' do
        session = double('session')
        allow(remote.session.sftp).to receive(:connect) { session }
        expect(fs.sftp).to be session
      end

      it 'memoizes the FS' do
        allow(remote.session.sftp).to receive(:connect) { Object.new }
        expect(fs.sftp).to be fs.sftp
      end
    end
  end
end
