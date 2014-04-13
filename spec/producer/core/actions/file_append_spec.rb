require 'spec_helper'

module Producer::Core
  module Actions
    describe FileAppend, :env do
      let(:path)          { 'some_path' }
      let(:content)       { 'some content' }
      let(:added_content) { ' added' }
      subject(:action)    { FileAppend.new(env, path, added_content) }

      it_behaves_like 'action'

      before { allow(remote_fs).to receive(:file_read).with(path) { content } }

      describe '#apply' do
        it 'appends given content to requested file on remote filesystem' do
          expect(remote_fs)
            .to receive(:file_write).with(path, action.combined_content)
          action.apply
        end
      end

      describe '#path' do
        it 'returns the file path' do
          expect(action.path).to eq path
        end
      end

      describe '#content' do
        it 'returns the content to append' do
          expect(action.content).to eq added_content
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
