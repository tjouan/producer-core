require 'spec_helper'

module Producer::Core
  class Remote
    describe FS do
      let(:remote)  { Remote.new('some_host.example') }
      subject(:fs)  { FS.new(remote) }

      describe '#initialize' do
        it 'assigns the remote given as argument' do
          expect(fs.remote).to be remote
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

      describe '#dir?' do
        let(:sftp)  { double('sftp').as_null_object }
        let(:path)  { 'some_directory_path' }
        let(:stat)  { double 'stat' }

        before do
          allow(fs).to receive(:sftp) { sftp }
          allow(sftp).to receive(:stat!).with(path) { stat }
        end

        context 'when path given as argument is a directory' do
          before { allow(stat).to receive(:directory?) { true } }

          it 'returns true' do
            expect(fs.dir? path).to be true
          end
        end

        context 'when path given as argument is not a directory' do
          before { allow(stat).to receive(:directory?) { false } }

          it 'returns false' do
            expect(fs.dir? path).to be false
          end
        end

        context 'when querying the path raises a Net::SFTP::StatusException' do
          before do
            response = double 'response', code: '42', message: 'some message'
            ex = Net::SFTP::StatusException.new(response)
            allow(sftp).to receive(:stat!).with(path).and_raise(ex)
          end

          it 'returns false' do
            expect(fs.dir? path).to be false
          end
        end
      end

      # FIXME: We rely a lot on mocking net-sftp heavily, while we already use a
      # part of net-ssh story helpers, which are more close to integration tests.
      describe '#file?', :ssh do
        let(:file_path) { 'some_file_path' }
        let(:stat)      { double 'stat' }

        before do
          sftp_story
          allow(fs.sftp).to receive(:stat!) { stat }
        end

        context 'when path given as argument exists' do
          context 'when path is a file' do
            before { allow(stat).to receive(:file?) { true } }

            it 'returns true' do
              expect(fs.file? file_path).to be true
            end
          end

          context 'when path is not a file' do
            before { allow(stat).to receive(:file?) { false } }

            it 'returns false' do
              expect(fs.file? file_path).to be false
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
            expect(fs.file? file_path).to be false
          end
        end
      end

      describe '#mkdir' do
        let(:sftp)  { double 'sftp' }
        let(:path)  { 'some_directory_path' }

        before { allow(fs).to receive(:sftp) { sftp } }

        it 'creates the directory' do
          expect(sftp).to receive(:mkdir!).with(path)
          fs.mkdir path
        end
      end

      describe '#file_read' do
        let(:sftp)    { double 'sftp' }
        let(:file)    { double 'file' }
        let(:f)       { double 'f' }
        let(:path)    { 'some_file_path' }
        let(:content) { 'some_content' }

        before do
          allow(fs).to receive(:sftp) { sftp }
          allow(sftp).to receive(:file) { file }
          allow(file).to receive(:open).and_yield(f)
          allow(f).to receive(:read) { content }
        end

        it 'returns the file content' do
          expect(fs.file_read(path)).to eq content
        end

        context 'when opening the file raises a Net::SFTP::StatusException' do
          before do
            response = double 'response', code: '42', message: 'some message'
            ex = Net::SFTP::StatusException.new(response)
            allow(file).to receive(:open).and_raise(ex)
          end

          it 'returns nil' do
            expect(fs.file_read(path)).to be nil
          end
        end
      end

      describe '#file_write' do
        let(:sftp)    { double 'sftp' }
        let(:file)    { double 'file' }
        let(:path)    { 'some_file_path' }
        let(:content) { 'some_content' }

        before do
          allow(fs).to receive(:sftp) { sftp }
          allow(sftp).to receive(:file) { file }
        end

        it 'opens the file' do
          expect(file).to receive(:open).with(path, 'w')
          fs.file_write path, content
        end

        it 'writes the content' do
          expect(file).to receive(:open).with(any_args) do |&b|
            expect(file).to receive(:write).with(content)
            b.call file
          end
          fs.file_write path, content
        end
      end
    end
  end
end
