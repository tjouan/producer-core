require 'spec_helper'

module Producer::Core
  module Actions
    describe FileWriter, :env do
      let(:path)        { 'some_path' }
      let(:content)     { 'some_content' }
      let(:options)     { { } }
      subject(:writer)  { described_class.new(env, path, content, options) }

      it_behaves_like 'action'

      describe '#setup' do
        let(:options) { { mode: 0700, user: 'root' } }

        it 'translates mode option as permissions' do
          expect(writer.options[:permissions]).to eq 0700
        end

        it 'translates user option as owner' do
          expect(writer.options[:owner]).to eq 'root'
        end

        context 'when content is missing' do
          let(:content) { nil }

          it 'raises ArgumentError' do
            expect { writer }.to raise_error ArgumentError
          end
        end
      end

      describe '#apply' do
        it 'writes content to file on remote filesystem' do
          expect(remote_fs)
            .to receive(:file_write).with(path, content)
          writer.apply
        end

        context 'when status options are given' do
          let(:options) { { group: 'wheel' } }

          it 'changes the directory status with given options' do
            expect(remote_fs).to receive(:setstat).with(path, options)
            writer.apply
          end
        end
      end
    end
  end
end
