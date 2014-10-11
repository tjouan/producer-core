require 'spec_helper'

module Producer::Core
  module Tests
    describe YAMLEq, :env do
      let(:filepath)  { 'some_file' }
      let(:data)      { { foo: 'bar' } }
      subject(:test)  { described_class.new(env, filepath, data, {}) }

      it_behaves_like 'test'

      describe '#verify' do
        context 'when file content matches' do
          before do
            allow(remote_fs)
              .to receive(:file_read).with(filepath) { ':foo: bar' }
          end

          it 'returns true' do
            expect(test.verify).to be true
          end
        end

        context 'when file content does not match' do
          before do
            allow(remote_fs)
              .to receive(:file_read).with(filepath) { ':foo: baz' }
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
