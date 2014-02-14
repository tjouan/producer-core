require 'spec_helper'

module Producer::Core
  module Actions
    describe FileWriter, :env do
      let(:path)        { 'some_path' }
      let(:content)     { 'some_content' }
      subject(:writer)  { FileWriter.new(env, path, content) }

      it_behaves_like 'action'

      describe '#apply' do
        it 'writes content to file on remote filesystem' do
          expect(remote_fs).to receive(:file_write).with(path, content)
          writer.apply
        end
      end

      describe '#path' do
        it 'returns the path' do
          expect(writer.path).to eq path
        end
      end

      describe '#content' do
        it 'returns the content' do
          expect(writer.content).to eq content
        end
      end
    end
  end
end
