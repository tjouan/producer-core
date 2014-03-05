require 'spec_helper'

module Producer::Core
  module Actions
    describe FileReplaceContent, :env do
      let(:path)        { 'some_path' }
      let(:pattern)     { 'content' }
      let(:replacement) { 'other content' }
      let(:content)     { 'some content' }
      subject(:action)  { FileReplaceContent.new(env, path, pattern, replacement) }

      it_behaves_like 'action'

      before { allow(remote_fs).to receive(:file_read).with(path) { content } }

      describe '#apply' do
        it 'writes replaced content to file on remote filesystem' do
          expect(remote_fs)
            .to receive(:file_write).with(path, action.replaced_content)
          action.apply
        end
      end

      describe '#path' do
        it 'returns the file path' do
          expect(action.path).to eq path
        end
      end

      describe '#pattern' do
        it 'returns the pattern' do
          expect(action.pattern).to eq pattern
        end
      end

      describe '#replacement' do
        it 'returns the replacement' do
          expect(action.replacement).to eq replacement
        end
      end

      describe '#replaced_content' do
        it 'returns content with pattern occurrences pattern replaced' do
          expect(action.replaced_content).to eq 'some other content'
        end
      end
    end
  end
end
