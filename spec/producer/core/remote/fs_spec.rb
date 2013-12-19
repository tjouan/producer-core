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
        expect(remote.session.sftp).to receive :connect
        fs.sftp
      end

      it 'returns the new SFTP session' do
        session = double 'session'
        allow(remote.session.sftp).to receive(:connect) { session }
        expect(fs.sftp).to be session
      end

      it 'memoizes the FS' do
        allow(remote.session.sftp).to receive(:connect) { Object.new }
        expect(fs.sftp).to be fs.sftp
      end
    end

    # FIXME: We rely a lot on mocking net-sftp heavily, while we already use a
    # part of net-ssh story helpers, which are more close to integration tests.
    describe '#has_file?', :ssh do
      let(:file_path) { "some_file_path" }
      let(:stat)      { double 'stat' }

      before do
        sftp_story
        allow(fs.sftp).to receive(:stat!) { stat }
      end

      context 'when path given as argument exists' do
        context 'when path is a file' do
          before { allow(stat).to receive(:file?) { true } }

          it 'returns true' do
            expect(fs.has_file? file_path).to be true
          end
        end

        context 'when path is not a file' do
          before { allow(stat).to receive(:file?) { false } }

          it 'returns false' do
            expect(fs.has_file? file_path).to be false
          end
        end
      end

      context 'when querying the path raises a Net::SFTP::StatusException' do
        before do
          response = double 'response', code: '42', message: 'some message'
          ex = Net::SFTP::StatusException.new(response)
          allow(stat).to receive(:file?).and_raise(ex)
        end

        it 'returns false' do
          expect(fs.has_file? file_path).to be false
        end
      end
    end
  end
end
