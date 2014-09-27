require 'spec_helper'

module Producer::Core
  module Tests
    describe FileMatch, :env do
      let(:filepath)  { 'some_file' }
      let(:pattern)   { /\Asome_content\z/ }
      subject(:test)  { described_class.new(env, filepath, pattern) }

      it_behaves_like 'test'

      describe '#verify' do
        context 'when file matches the pattern' do
          before do
            allow(remote_fs)
              .to receive(:file_read).with(filepath) { 'some_content' }
          end

          it 'returns true' do
            expect(test.verify).to be true
          end
        end

        context 'when file does not match the pattern' do
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
