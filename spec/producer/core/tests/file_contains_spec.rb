require 'spec_helper'

module Producer::Core
  module Tests
    describe FileContains, :env do
      let(:filepath)  { 'some_file' }
      let(:content)   { 'some_content' }
      subject(:test)  { described_class.new(env, filepath, content) }

      it_behaves_like 'test'

      describe '#verify' do
        context 'when file contains the content' do
          before do
            allow(remote_fs)
              .to receive(:file_read).with(filepath) { "foo#{content}bar" }
          end

          it 'returns true' do
            expect(test.verify).to be true
          end
        end

        context 'when file does not contain the content' do
          before do
            allow(remote_fs).to receive(:file_read).with(filepath) { 'foo bar' }
          end

          it 'returns false' do
            expect(test.verify).to be false
          end
        end

        context 'when file does not exist' do
          before do
            allow(remote_fs).to receive(:file_read).with(filepath) { nil }
          end

          it 'returns false' do
            expect(test.verify).to be false
          end
        end
      end
    end
  end
end
