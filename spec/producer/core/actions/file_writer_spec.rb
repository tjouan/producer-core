require 'spec_helper'

module Producer::Core
  module Actions
    describe FileWriter, :env do
      let(:path)        { 'some_path' }
      let(:content)     { 'some_content' }
      subject(:writer)  { described_class.new(env, path, content) }

      it_behaves_like 'action'

      describe '#apply' do
        it 'writes content to file on remote filesystem' do
          expect(remote_fs).to receive(:file_write).with(path, content)
          writer.apply
        end

        context 'when a mode was given' do
          subject(:writer) { described_class.new(env, path, content, 0600) }

          it 'specifies the given mode' do
            expect(remote_fs)
              .to receive(:file_write).with(anything, anything, 0600)
            writer.apply
          end
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

      describe '#mode' do
        it 'returns nil' do
          expect(writer.mode).to be nil
        end

        context 'when a mode was given' do
          subject(:writer) { described_class.new(env, path, content, 0600) }

          it 'returns the mode' do
            expect(writer.mode).to eq 0600
          end
        end
      end
    end
  end
end
