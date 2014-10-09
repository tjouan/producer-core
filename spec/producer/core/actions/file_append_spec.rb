require 'spec_helper'

module Producer::Core
  module Actions
    describe FileAppend, :env do
      let(:path)          { 'some_path' }
      let(:content)       { 'some content' }
      let(:added_content) { ' added' }
      subject(:action)    { described_class.new(env, path, added_content) }

      it_behaves_like 'action'

      before { allow(remote_fs).to receive(:file_read).with(path) { content } }

      describe '#setup' do
        context 'when content is missing' do
          let(:added_content) { nil }

          it 'raises ArgumentError' do
            expect { action }.to raise_error ArgumentError
          end
        end
      end

      describe '#apply' do
        it 'appends given content to requested file on remote filesystem' do
          expect(remote_fs)
            .to receive(:file_write).with(path, action.combined_content)
          action.apply
        end
      end

      describe '#combined_content' do
        it 'returns original content and added content combined' do
          expect(action.combined_content).to eq 'some content added'
        end

        context 'when fs.file_read returns nil' do
          before { allow(remote_fs).to receive(:file_read).with(path) { nil } }

          it 'returns only the added content' do
            expect(action.combined_content).to eq ' added'
          end
        end
      end
    end
  end
end
