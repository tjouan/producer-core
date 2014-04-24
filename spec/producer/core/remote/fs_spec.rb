require 'spec_helper'

module Producer::Core
  class Remote
    describe FS do
      let(:sftp_file) { double 'sftp_file' }
      let(:sftp)      { double('sftp', file: sftp_file) }
      subject(:fs)    { FS.new(sftp) }

      describe '#initialize' do
        it 'assigns the sftp session' do
          expect(fs.sftp).to be sftp
        end
      end

      describe '#dir?' do
        let(:path)  { 'some_directory_path' }
        let(:stat)  { double 'stat' }

        before { allow(sftp).to receive(:stat!).with(path) { stat } }

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

      describe '#file?' do
        let(:file_path) { 'some_file_path' }
        let(:stat)      { double 'stat' }

        before { allow(sftp).to receive(:stat!) { stat } }

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
        let(:path) { 'some_directory_path' }

        it 'creates the directory' do
          expect(sftp).to receive(:mkdir!).with(path)
          fs.mkdir path
        end
      end

      describe '#file_read' do
        let(:f)       { double 'f' }
        let(:path)    { 'some_file_path' }
        let(:content) { 'some_content' }

        before do
          allow(sftp_file).to receive(:open).and_yield(f)
          allow(f).to receive(:read) { content }
        end

        it 'returns the file content' do
          expect(fs.file_read(path)).to eq content
        end

        context 'when opening the file raises a Net::SFTP::StatusException' do
          before do
            response = double 'response', code: '42', message: 'some message'
            ex = Net::SFTP::StatusException.new(response)
            allow(sftp_file).to receive(:open).and_raise(ex)
          end

          it 'returns nil' do
            expect(fs.file_read(path)).to be nil
          end
        end
      end

      describe '#file_write' do
        let(:path)    { 'some_file_path' }
        let(:content) { 'some_content' }

        it 'opens the file' do
          expect(sftp_file).to receive(:open).with(path, 'w', anything)
          fs.file_write path, content
        end

        it 'writes the content' do
          expect(sftp_file).to receive(:open).with(any_args) do |&b|
            expect(sftp_file).to receive(:write).with(content)
            b.call sftp_file
          end
          fs.file_write path, content
        end

        it 'accepts an optional mode argument' do
          expect(sftp_file).to receive(:open).with(anything, anything, 0600)
          fs.file_write path, content, 0600
        end
      end
    end
  end
end
