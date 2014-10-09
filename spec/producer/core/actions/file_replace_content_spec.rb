require 'spec_helper'

module Producer::Core
  module Actions
    describe FileReplaceContent, :env do
      let(:path)        { 'some_path' }
      let(:pattern)     { 'content' }
      let(:replacement) { 'other content' }
      let(:content)     { 'some content' }
      let(:arguments)   { [path, pattern, replacement] }
      subject(:action)  { described_class.new(env, *arguments) }

      it_behaves_like 'action'

      before { allow(remote_fs).to receive(:file_read).with(path) { content } }

      describe '#setup' do
        context 'when content is missing' do
          let(:replacement) { nil }

          it 'raises ArgumentError' do
            expect { action }.to raise_error ArgumentError
          end
        end
      end

      describe '#apply' do
        it 'writes replaced content to file on remote filesystem' do
          expect(remote_fs)
            .to receive(:file_write).with(path, action.replaced_content)
          action.apply
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
